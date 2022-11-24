# test-rinextools
Docker setup for testing RINEX tools for GORM 2.0

Traditional suites and processes:

* Decompress GZIP : `gzip`
* Decompress Hatanaka (CRX) : `CRX2RNX`
* Rewrite RINEX headers : custom Perl script
* Gap analysis : custom Perl script 
* QC : `bnc` or `anubis`
* splice/merge : `gfzrnx` or `bnc`
* Compress Hatanaka : `RNX2CRX`
* Compress : `gzip` 

Can we possibly replace this with the [`rinex`](https://github.com/gwbres/rinex)-based rinex-cli?

* Decompress GZIP : `rinex` (`flate2`)
* Decompress Hatanaka (CRX) : `rinex`
* Rewrite RINEX headers : `rinex`
* Gap analysis : `rinex`
* QC : `rinex`
* splice/merge : `rinex`
