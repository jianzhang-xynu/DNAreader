import numpy as np
import math
import torch
import torch.nn as nn

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

esm_embeddings=320
input_esm_dim=esm_embeddings
dim1=10
dim2=5

# ===================================================
# Transformer model parameters (per-residue features)
TRF_input=90
d_ff = 128
d_k = d_v = 32
n_heads = 8
n_layers = 3
TRF_output = 90
fixed_window = 15

# fully-connected layer parameters
predFCL_dim1 = 40
predFCL_dim2 = 20
predFCL_dim3 = 10
predFCL_dim4 = 5

class MainModel(nn.Module):
    def __init__(self, input_esm_dim, TRF_input):
        super(MainModel, self).__init__()

        # ------------------------------ESM2---------------------------------------------
        self.ESM2 = nn.Sequential()
        self.ESM2.add_module('ESM2', FCL3layers(input_esm_dim, dim1, dim2))
        # ------------------------------ESM2---------------------------------------------

        # ------------------------------Transformer--------------------------------------
        self.TRF_layer = Transformer(TRF_input, TRF_output)
        # ------------------------------Transformer--------------------------------------

        # ------------------------------Fully connected layers---------------------------
        self.PredLayers = nn.Sequential()
        self.PredLayers.add_module('PredLayers', FCL4layers(TRF_output, predFCL_dim1, predFCL_dim2, predFCL_dim3, predFCL_dim4))
        # ------------------------------Fully connected layers---------------------------

    def forward(self, embedding_feas, computed_feas):

        output_ESM2 = self.ESM2(embedding_feas)
        new_ESM2_output = output_ESM2.cpu().detach().numpy()
        rows, cols = new_ESM2_output.shape

        half_size = fixed_window // 2
        valid_output = []
        for idx in range(rows):
            win_start = idx - half_size
            win_end = idx + half_size
            valid_end = min(win_end, rows - 1)

            pre_zeros_PADs = None
            post_zeros_PADs = None

            # -----------------------------------------------
            if win_start < 0:
                pre_zeros_PADs = np.zeros((0 - win_start, cols))

            win_start = max(0, win_start)
            valid_feas = np.array(new_ESM2_output)[win_start:valid_end + 1, :]

            if valid_end < win_end:
                post_zeros_PADs = np.zeros((win_end - valid_end, cols))

            if pre_zeros_PADs is not None:
                valid_feas = np.concatenate([pre_zeros_PADs, valid_feas], axis=0)
            if post_zeros_PADs is not None:
                valid_feas = np.concatenate([valid_feas, post_zeros_PADs], axis=0)

            valid_output.append(valid_feas)

        fixed_window_outESM2 = torch.Tensor(np.array(valid_output)).to(device)
        fixed_window_outESM2 = fixed_window_outESM2.view(-1, fixed_window, 25)

        comb_feas = torch.cat((fixed_window_outESM2, computed_feas), 2)
        output_TRF = self.TRF_layer(comb_feas)

        final_pred = self.PredLayers(output_TRF)

        return final_pred



class FCL3layers(nn.Module):
    def __init__(self, input_esm_dim, dim1, dim2):
        super(FCL3layers, self).__init__()
        self.window_size=5
        self.linear1 = nn.Linear(input_esm_dim, dim1, bias=False)
        self.activation1 = nn.ReLU()
        self.dropout1 = nn.Dropout(0.4)
        self.linear2 = nn.Linear(dim1, dim2)
        self.activation2 = nn.ReLU()
        self.dropout2 = nn.Dropout(0.4)

    def forward(self, x):
        features = self.linear1(x)
        features = self.activation1(features)
        features = self.dropout1(features)
        features = self.linear2(features)
        features = self.dropout2(features)
        temp_output = self.activation2(features)

        new_temp_output = temp_output.cpu().detach().numpy()
        rows, cols = new_temp_output.shape

        half_size = self.window_size // 2
        valid_output = []
        for idx in range(rows):
            win_start = idx - half_size
            win_end = idx + half_size
            valid_end = min(win_end, rows - 1)

            pre_zeros_PADs = None
            post_zeros_PADs = None

            # -----------------------------------------------
            if win_start < 0:
                pre_zeros_PADs = np.zeros((0 - win_start, cols))

            win_start = max(0, win_start)
            valid_features = np.array(new_temp_output)[win_start:valid_end + 1, :]

            if valid_end < win_end:
                post_zeros_PADs = np.zeros((win_end - valid_end, cols))

            if pre_zeros_PADs is not None:
                valid_features = np.concatenate([pre_zeros_PADs, valid_features], axis=0)
            if post_zeros_PADs is not None:
                valid_features = np.concatenate([valid_features, post_zeros_PADs], axis=0)

            valid_output.append(valid_features)

        output = torch.Tensor(np.array(valid_output)).to(device)
        output = output.view(-1, 25)
        return output


class FCL4layers(nn.Module):
    def __init__(self, input_esm_dim, dim1, dim2, dim3, dim4):
        super(FCL4layers, self).__init__()
        self.linear1 = nn.Linear(input_esm_dim, dim1, bias=False)
        self.activation1 = nn.ReLU()
        self.dropout1 = nn.Dropout(0.3)
        self.linear2 = nn.Linear(dim1, dim2)
        self.activation2 = nn.ReLU()
        self.dropout2 = nn.Dropout(0.3)
        self.linear3 = nn.Linear(dim2, dim3)
        self.activation3 = nn.ReLU()
        self.linear4 = nn.Linear(dim3, dim4)
        self.activation4 = nn.ReLU()
        self.linear5 = nn.Linear(dim4, 1)
        self.activation5 = nn.Sigmoid()

    def forward(self, x):
        output_features = x
        features = self.linear1(x)
        features = self.activation1(features)
        features = self.dropout1(features)
        features = self.linear2(features)
        features = self.activation2(features)
        features = self.dropout2(features)
        features = self.linear3(features)
        features = self.activation3(features)
        features = self.linear4(features)
        features = self.activation4(features)
        features = self.linear5(features)
        FCL4layers_output = self.activation5(features)

        return output_features, FCL4layers_output




# ===================================================
# ===================================================
class Transformer(nn.Module):
    def __init__(self,d_model,TRF_output):
        super(Transformer, self).__init__()
        self.encoder = Encoder(d_model)  # checking
        self.projection = nn.Linear(d_model, TRF_output, bias=False)

    def forward(self, enc_inputs):
        enc_outputs, enc_self_attns = self.encoder(enc_inputs)
        dec_logits = self.projection(enc_outputs)

        # return dec_logits.view(-1,dec_logits.size(-1)), enc_self_attns
        # print(dec_logits)
        mid_window_scores = dec_logits[:, fixed_window // 2, :]

        return mid_window_scores.squeeze(1)


class Encoder(nn.Module):
    def __init__(self,d_model):
        super(Encoder, self).__init__()
        self.pos_emb = PositionalEncoding(d_model)  # checked
        self.layers = nn.ModuleList(EncoderLayer(d_model) for _ in range(n_layers))  # checking

    def forward(self, enc_inputs):
        enc_outputs = self.pos_emb(enc_inputs.transpose(0, 1)).transpose(0, 1)
        enc_self_attn_mask = get_attn_pad_mask()

        enc_self_attns = []
        for layer in self.layers:
            enc_outputs, enc_self_attn = layer(enc_outputs, enc_self_attn_mask)
            enc_self_attns.append(enc_self_attn)
        return enc_outputs, enc_self_attns


class PositionalEncoding(nn.Module):
    def __init__(self, d_model, dropout=0.3, max_len=5000):
        super(PositionalEncoding, self).__init__()
        self.dropout = nn.Dropout(p=dropout)  # checked
        pe = torch.zeros(max_len, d_model)  #
        position = torch.arange(0, max_len, dtype=torch.float).unsqueeze(1)  #
        div_term = torch.exp(torch.arange(0, d_model, 2).float() * (-math.log(10000.0) / d_model))

        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)

        pe = pe.unsqueeze(0).transpose(0, 1)

        self.register_buffer('pe', pe)

    def forward(self, x):  # x: [seq_len, batch_size, d_model]
        x = x + self.pe[:x.size(0), :]
        return self.dropout(x)


class EncoderLayer(nn.Module):
    def __init__(self,d_model):
        super(EncoderLayer, self).__init__()
        self.enc_self_attn = MultiHeadAttention(d_model)
        self.pos_ffn = PoswiseFeedForwardNet(d_model)

    def forward(self, enc_inputs, enc_self_attn_mask):
        enc_outputs, attn = self.enc_self_attn(enc_inputs, enc_inputs, enc_inputs, enc_self_attn_mask)
        enc_outputs = self.pos_ffn(enc_outputs)
        return enc_outputs, attn


class MultiHeadAttention(nn.Module):
    def __init__(self,d_model):
        super(MultiHeadAttention, self).__init__()

        self.W_Q = nn.Linear(d_model, d_k * n_heads, bias=False)
        self.W_K = nn.Linear(d_model, d_k * n_heads, bias=False)
        self.W_V = nn.Linear(d_model, d_v * n_heads, bias=False)

        self.fc = nn.Linear(n_heads * d_v, d_model, bias=False)
        self.layer_norm = nn.LayerNorm(d_model)

    def forward(self, input_Q, input_K, input_V, attn_mask):
        residual, batch_size = input_Q, input_Q.size(0)

        Q = self.W_Q(input_Q).view(batch_size, -1, n_heads, d_k).transpose(1, 2)
        K = self.W_K(input_K).view(batch_size, -1, n_heads, d_k).transpose(1, 2)
        V = self.W_V(input_V).view(batch_size, -1, n_heads, d_v).transpose(1, 2)
        #  Q, K, V[1,8,7,64]
        attn_mask = attn_mask.unsqueeze(1).repeat(1, n_heads, 1, 1).to(device)
        context, attn = ScaledDotProductAttention()(Q, K, V, attn_mask)

        context = context.transpose(1, 2).reshape(batch_size, -1, n_heads * d_v)
        # context.transpose(1, 2) ---> context[1,7,8,64]

        output = self.fc(context)
        output = self.layer_norm(output + residual)
        return output, attn


class ScaledDotProductAttention(nn.Module):
    def __init__(self):
        super(ScaledDotProductAttention, self).__init__()

    def forward(self, Q, K, V, attn_mask):
        scores = torch.matmul(Q, K.transpose(-1, -2)) / np.sqrt(d_k)
        scores.masked_fill_(attn_mask, -1e9)
        attn = nn.Softmax(dim=-1)(scores)

        context = torch.matmul(attn, V)
        return context, attn


class PoswiseFeedForwardNet(nn.Module):
    def __init__(self,d_model):
        super(PoswiseFeedForwardNet, self).__init__()
        self.fc = nn.Sequential(
            nn.Linear(d_model, d_ff, bias=False),
            nn.ReLU(),
            nn.Linear(d_ff, d_model, bias=False),
            nn.LayerNorm(d_model)
        )

    def forward(self, inputs):
        residual = inputs
        output = self.fc(inputs)
        return (output + residual)


# ------------------------------------------------
#
#
# ------------------------------------------------


def get_attn_pad_mask():
    oriMask = [[False] * fixed_window for _ in range(fixed_window)]
    for row in range(len(oriMask[0])):
        for col in range(len(oriMask[1])):
            if row == fixed_window // 2 or col == fixed_window // 2:
                oriMask[row][col] = True

    pad_attn_mask = torch.Tensor(oriMask).bool().to(device)

    return pad_attn_mask.expand(1, fixed_window, fixed_window)

# ===================================================
# ===================================================

class AverageMeter(object):
    """
    Computes and stores the average and current value
    Copied from: https://github.com/pytorch/examples/blob/master/imagenet/main.py
    """
    # reset()
    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count
# ===================================================
# ===================================================



#myModel = MainModel(esm_embeddings, TRF_input).to(device)
#print(myModel)

#print(myModel)
#for name, param in myModel.named_parameters():
#    print(name,'-->',param.type(),'-->',param.dtype,'-->',param.shape)


