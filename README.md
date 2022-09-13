# test-rinextools
Docker setup for testing RINEX tools

Traditional suite:

* Decompress GZIP : `gzip`
* Decompress Hatanaka (CRX) : `CRX2RNX`
* Rewrite RINEX headers : custom Perl script
* Gap analysis : custom Perl script 
* QC : `bnc` or `anubis`
* splice/merge : `gfzrnx` or `bnc`
* Compress Hatanaka : `RNX2CRX`
* Compress : `gzip`
* 
Can we replace this with:

* Decompress GZIP : `rinex` (`flate2`)
* Decompress Hatanaka (CRX) : `rinex`
* Rewrite RINEX headers : `rinex`
* Gap analysis : `rinex`
* QC : `rinex`
* splice/merge : `rinex`
