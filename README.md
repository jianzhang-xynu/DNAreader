# DNAreader

DNAreader is designed for accurate residue-level prediction of DNA-binding residues in both structure-annotated and disorder-annotated proteins.

## Web Server

Access the DNAreader web server at:

https://biomine.cs.vcu.edu/servers/DNAreader/

## Web Server

The open-source implementation is available on GitHub:

https://github.com/jianzhang-xynu/DNAreader

# Benchmark datasets

The benchmark_datasets folder contains the datasets used for model training and evaluation.

# Installation 

## Facebook's ESM2 model

DNAreader relies on ESM2 for residue embedding.

Install it via: https://github.com/facebookresearch/esm. 

You can use the following command for the latest release:

```
pip install fair-esm  # latest release, OR:
```

Bleeding-Edge Version (GitHub Main Branch)

```
pip install git+https://github.com/facebookresearch/esm.git 
```

Note: This study uses esm2_t6_8M_UR50D (8M parameters) for residue embeddings.

## Required Third-Part Software

* ASAquick
Fast neural network-based predictor of solvent accessibility

Install it via: http://mamiris.com/services.html

- Modify line 22 of 'serverScript/1_genRSA.plx'  

  ```
  system "/home/ubuntu/ASAquick/bin/ASAquick ..."
  ```  
  as follows:  

  ```
  system "/yourPath/ASAquick ..." # Replace with your installation path
  ```  

* HHblits
Detection of Remote Homologous Proteins

Install it via: https://github.com/soedinglab/hh-suite

The user needs to check the path of the HHblits in serverScript/2_genECO.plx.

- Modify line 10 of 'serverScript/2_genECO.plx'  

  ```
  $hhblit_dir="/home/userver/hhblits/hhsuite-3.3.0";
  ```  
  as follows:  

  ```
  $hhblit_dir="/yourPath/hhsuite-3.3.0"; # Replace with your installation path
  ```

* IUPred3
Prediction of Intrinsically Disorder

Install it via: https://iupred3.elte.hu/

The user needs to check the path of the IUPred3 in serverScript/3_genDISO.plx.

- Modify line 17 and 18 of 'serverScript/3_genDISO.plx'  

  ```
  $IUPRED3A_dir="/home/ubuntu/iupred3";
  ```  
  as follows:  

  ```
  $IUPRED3A_dir="/yourPath/iupred3"; # Replace with your installation path
  ``` 
  

* CLIP
Prediction of Linear Interacting Peptides

Install it via: http://yanglab.qd.sdu.edu.cn/download/CLIP/

The user needs to check the path of the CLIP in serverScript/6_runCLIP.plx.

- Modify line 30 of 'serverScript/6_runCLIP.plx'  

  ```
  my $CLIPdir="/home/userver/CLIP/bin";
  ```  
  as follows:  

  ```
  my $CLIPdir="/yourPath/CLIP/bin"; # Replace with your installation path
  ```  


## Required Libraries

```
pip install numpy
pip install scipy
pip install pytorch==1.12.0 (or GPU supported pytorch, refer to https://pytorch.org/ for instructions)
```


# Running Predictions

Use command

```
$ ./genALL.plx 'jobID'
```

to run predictions, where 'jobID' is a folder containing FASTA-formatted protein sequences.

For instance,

```
$ ./genALL.plx example
```

# Running on GPU or CPU

If you want to use GPU, you also need to install CUDA and cuDNN; please refer to their websites for instructions.

The code has been tested on both GPU and CPU-only computer.


# Citation

Upon the usage the users are requested to use the following citation:

Jian Zhang, Sushmita Basu, Jingjing Qian, Lukasz Kurgan. DNAreader: Accurate prediction of DNA-binding residues in structured and disordered proteins using transformers and contrastive learning.
