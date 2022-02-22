/* Quartus II Version 9.0 Build 184 04/29/2009 Service Pack 1 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(EPC4) MfrSpec(OpMask(0) FullPath("G:/pciusbtest_90sp1/output_file.pof"));
	P ActionCode(Cfg)
		Device PartName(EPF10K200SR240) Path("G:/pciusbtest_90sp1/") File("pciusbtest_90sp1.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
