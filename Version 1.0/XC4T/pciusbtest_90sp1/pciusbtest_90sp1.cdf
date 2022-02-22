/* Quartus II Version 9.0 Build 235 06/17/2009 Service Pack 2 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Cfg)
		Device PartName(EPC4) Path("C:/altera/90sp1/quartus/pciusbtest_90sp1/") File("output_file.pof") MfrSpec(OpMask(1));
	P ActionCode(Cfg)
		Device PartName(EPF10K200SR240) Path("c:/altera/90sp1/quartus/pciusbtest_90sp1/") File("pciusbtest_90sp1.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
