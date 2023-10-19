# test-rinextools
Docker setup for testing RINEX tools

Current suites and processes:

* Decompress GZIP : `gzip`
* Decompress Hatanaka (CRX) : `CRX2RNX`
* Rewrite RINEX headers : custom Perl script
* Gap analysis : custom Perl script 
* QC : `anubis`
* splice/merge : `gfzrnx` or `bnc`
* Compress Hatanaka : `RNX2CRX`
* Compress : `gzip` 

Can we possibly replace this with the [`rinex`](https://github.com/gwbres/rinex)-based rinex-cli?

* Decompress GZIP : `rinex-cli` ( using `flate2`)
* Decompress Hatanaka (CRX) : `rinex-cli`
* Rewrite RINEX headers : `rinex-cli`
* Gap analysis : `rinex-cli`
* QC : `rinex-cli`
* splice/merge : `rinex-cli`

We need to write a kind of tutorial.