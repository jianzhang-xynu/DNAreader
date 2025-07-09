import sys
from loadDataset2 import *
from myModel import *
from torch.utils.data import DataLoader
import os

taskID = sys.argv[1]

fixed_window = 15
esm_embeddings_dim=320
input_esm_dim=esm_embeddings_dim
TRF_input=90

def for_TEST_experi(model, loader):
    model.eval()
    all_DNA_preds = []

    iter_results = ''

    for batch_idx, (computedfeas, ESM2feas) in enumerate(loader):
        with torch.no_grad():
            temp_feas_computed = torch.autograd.Variable(computedfeas.to(torch.float32).to(device))
            feas_computed = temp_feas_computed.view(-1, fixed_window, dim_computed_feas)

            feas_ESM2 = torch.autograd.Variable(ESM2feas.to(torch.float32).to(device))

        output_features, DNA_preds = model(feas_ESM2, feas_computed)

        all_DNA_preds.append(DNA_preds.data.cpu().numpy())

    all_DNA_preds = np.concatenate(all_DNA_preds, axis=0).flatten()
    print("Predicted results: Done")

    return all_DNA_preds

#-------------------------------------------------------------#
#
#  main function is as below
#
#-------------------------------------------------------------#


print('===========================')
test_dataset = dataSet(taskID)
print('Test_dataset is done')

myModel = MainModel(input_esm_dim, TRF_input).to(device)

print('===========================')
print('Model Construction is done')

test_loader = DataLoader(test_dataset, batch_size=256, pin_memory=True, num_workers=8, drop_last=False)
print('===========================')
print('Test_loader is done')
print('===========================')

path_dir = "./FINALmodel/"
myModel.load_state_dict(torch.load(os.path.join(path_dir, 'model_weights_33.dat')))

all_DNA_preds = for_TEST_experi (model=myModel, loader=test_loader)
print("Test is done")

with open('{0}/temp_pro.tempPred'.format(taskID), 'w', encoding="utf-8") as fw_DNA:
    for idx, values in enumerate(all_DNA_preds):
        fw_DNA.write(str(round(values, 5))+"\n")
fw_DNA.close()





