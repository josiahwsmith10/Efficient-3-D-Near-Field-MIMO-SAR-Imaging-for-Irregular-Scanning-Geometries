# Efficient 3-D Near-Field MIMO-SAR Imaging for Irregular Scanning Geometries
Code to accompany our paper "Efficient 3-D Near-Field MIMO-SAR Imaging for Irregular Scanning Geometries" ([arXiv](https://arxiv.org/abs/2305.02064), [DOI](https://doi.org/10.1109/ACCESS.2022.3145370)).

- This code provides several examples for simulating multi-planar multistatic scenarios and recovering the image using the proposed algorithm (EMPM: Efficient Multis-Planar Multistatic) or conventional backprojection algorithm (BPA). 
- This project relies on the [Terhertz Imaging Toolbox with Interactive User Interface](https://github.com/josiahwsmith10/THz-and-Sub-THz-Imaging-Toolbox) for simulation. The THz toolbox must be installed for any of this code to work. 
- The work in this paper was extended in our follow-up works proposing data-driven algorithms for improving images reconstructed using the EMPM algorithm: "A Vision Transformer Approach for Efficient Near-Field SAR Super-Resolution under Array Perturbation" ([arXiv](https://arxiv.org/abs/2305.02074), [DOI](https://doi.org/10.1109/WMCS55582.2022.9866326)) and "Efficient CNN-Based Super Resolution Algorithms for mmWave Mobile Radar Imaging" ([arXiv](https://arxiv.org/abs/2305.02092), [DOI](https://doi.org/10.1109/ICIP46576.2022.9897190)). 

### Publication and Citation
If you appreciate our work, please cite as
```
@article{smith2022efficient,
	title        = {Efficient {3-D} Near-Field {MIMO-SAR} Imaging for Irregular Scanning Geometries},
	author       = {Smith, J. W. and Torlak, Murat},
	year         = 2022,
	month        = jan,
	journal      = {IEEE Access},
	volume       = 10,
	pages        = {10283--10294}
}
@inproceedings{smith2022vision,
	title        = {A Vision Transformer Approach for Efficient Near-Field {SAR} Super-Resolution under Array Perturbation},
	author       = {Smith, J. W. and Alimam, Y. and Vedula, G. and Torlak, M.}
	year         = 2022,
	month        = apr,
	booktitle    = {Proc. IEEE Tex. Symp. Wirel. Microw. Circuits Syst. (WMCS)},
	address      = {Waco, TX, USA},
	pages        = {1--6}
}
@inproceedings{vasileiou2022efficient,
	title        = {Efficient {CNN}-Based Super Resolution Algorithms for {mmWave} Mobile Radar Imaging},
	author       = {Vasileiou, C. and Smith, J. W. and Thiagarajan, S. and Nigh, M. and Makris, Y. and Torlak, M.},
	year         = 2022,
	month        = oct,
	booktitle    = {Proc. IEEE Int. Conf. Image Process. (ICIP)},
	address      = {Bordeaux, France},
	pages        = {3803--3807}
}
```

## License
[GPL 3.0](https://choosealicense.com/licenses/gpl-3.0/)
