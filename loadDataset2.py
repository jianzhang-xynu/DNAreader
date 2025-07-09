import torch
import numpy
import sys
from collections import OrderedDict
from torch.utils import data
import esm

taskID = sys.argv[1]
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

esm_embeddings_dim=320
esm_model, alphabet = esm.pretrained.load_model_and_alphabet("./ESM_models/esm2_t6_8M_UR50D.pt")
batch_converter = alphabet.get_batch_converter()
esm_model.eval()

dim_computed_feas=65
fixed_window=15
#===================================================================

def get_data_mess(file_name):

    allproID_feas = OrderedDict()
    all_proID = []
    proID = "temp_pro"

    allproID_feas[proID] = {}
    all_proID.append(proID)
    computed_feas = []

    with open('{0}/temp_pro.fasta'.format(taskID), 'r') as fr_profastas:
        lines = fr_profastas.readlines()
    second_line = lines[1].strip()

    thisTemp = [(proID, second_line)]
    # print(thisTemp)

    batch_labels, batch_strs, batch_tokens = batch_converter(thisTemp)
    batch_lens = (batch_tokens != alphabet.padding_idx).sum(1)

    with torch.no_grad():
        results = esm_model(batch_tokens, repr_layers=[6])
    token_representations = results["representations"][6]
    # encoding sequences
    fea_embeddings = []
    fea_embeddings = torch.FloatTensor(fea_embeddings).view(-1, 320)

    for idx, tokens_len in enumerate(batch_lens):
        esm_representation = token_representations[idx, 1: tokens_len - 1]
        fea_embeddings = torch.cat([fea_embeddings, esm_representation], 0)
    # print(fea_embeddings.shape)

    allproID_feas[proID]['esm_feas'] = fea_embeddings.tolist()
    # ---------------------------------------------------------------------

    with open('{0}/feasfolder/temp_pro.computedfeas'.format(taskID), 'r') as fr_comp_feas:
        for everyline in fr_comp_feas:
            everyline = everyline.strip()
            if everyline:
                everyline = [float(i) for i in everyline.split(',')]
                computed_feas.append(everyline)
    allproID_feas[proID]['computed_feas'] = computed_feas

    return allproID_feas, all_proID

class dataSet(data.Dataset):
    def __init__(self,file_name):
        self.window_size = fixed_window
        self.allproID_features, self.allproteinID = get_data_mess(file_name)

        self.all_samples_list = []

        all_count=-1
        for idx_proID, key_proID in enumerate(self.allproteinID):
            for jdx, sbind in enumerate(self.allproID_features[key_proID]['computed_feas']):
                all_count += 1

                temp_s = [all_count, idx_proID, jdx, len(self.allproID_features[key_proID]['computed_feas'])]
                self.all_samples_list.append(temp_s)


    def __getitem__(self, samp_idx):

        count, proid_idx, resi_jdx, this_seq_len = self.all_samples_list[samp_idx]
        proid_idx, resi_jdx, this_seq_len = int(proid_idx), int(resi_jdx), int(this_seq_len)

        # =============================================
        # only use this residue embeddings
        get_esm_feas = numpy.array(self.allproID_features[self.allproteinID[proid_idx]]['esm_feas'])[resi_jdx,:]
        #get_comp_feas = numpy.array(self.allproID_features[self.allproteinID[proid_idx]]['computed_feas'])[resi_jdx, :]
        # =============================================
        # use window-level residue embeddings


        half_size = self.window_size//2

        win_start = resi_jdx - half_size
        win_end = resi_jdx + half_size
        valid_end = min(win_end, this_seq_len - 1)

        pre_zeros_PADs=None
        post_zeros_PADs=None
        #-----------------------------------------------
        if win_start < 0:
            pre_zeros_PADs = numpy.zeros((0 - win_start, dim_computed_feas))

        win_start = max(0, win_start)

        valid_features = numpy.array(self.allproID_features[self.allproteinID[proid_idx]]['computed_feas'])[win_start:valid_end + 1,:]

        if valid_end < win_end:
            post_zeros_PADs = numpy.zeros((win_end - valid_end, dim_computed_feas))

        if pre_zeros_PADs is not None:
            valid_features = numpy.concatenate([pre_zeros_PADs, valid_features], axis=0)
        if post_zeros_PADs is not None:
            valid_features = numpy.concatenate([valid_features, post_zeros_PADs], axis=0)

        valid_features = valid_features[numpy.newaxis, :, :]
        get_comp_feas = valid_features.flatten()
        #print(get_comp_feas.shape)
        #=============================================
        return get_comp_feas, get_esm_feas
        #=============================================
    def __len__(self):
        return len(self.all_samples_list)

    def get_all_pro_ID(self):
        return self.proteinID

