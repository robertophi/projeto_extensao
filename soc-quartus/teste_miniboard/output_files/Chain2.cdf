/* Quartus II 32-bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Cfg)
		Device PartName(EP2C5T144) Path("/home/roberto/dev/soc-quartus/teste_miniboard/output_files/") File("MiniBoardLed.sof") MfrSpec(OpMask(1));
	P ActionCode(Ign)
		Device PartName(EP2C5) MfrSpec(OpMask(0));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
