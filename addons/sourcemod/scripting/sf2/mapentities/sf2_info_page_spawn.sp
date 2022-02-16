// sf2_info_page_spawn

static CEntityFactory g_entityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2PageSpawnEntity < CBaseEntity
{
	public SF2PageSpawnEntity(int entIndex) { return view_as<SF2PageSpawnEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
			return false;

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_entityFactory;
	}

	public void GetPageModel(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sModel", sBuffer, iBufferLen);
	}

	public void SetPageModel(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_sModel", sBuffer);
	}

	property int PageSkin
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iSkin"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iSkin", value); }
	}

	property float PageModelScale
	{
		public get() { return this.GetPropFloat(Prop_Data, "sf2_flModelScale"); }
		public set(float value) { this.SetPropFloat(Prop_Data, "sf2_flModelScale", value); }
	}

	property int PageBodygroup
	{
		public get() { return this.GetProp(Prop_Data, "sf2_iBodyGroup"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iBodyGroup", value); }
	}

	public void GetPageGroup(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sGroup", sBuffer, iBufferLen);
	}

	public void SetPageGroup(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_sGroup", sBuffer);
	}

	public void GetPageAnimation(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sAnimation", sBuffer, iBufferLen);
	}

	public void SetPageAnimation(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_sAnimation", sBuffer);
	}

	public void GetPageCollectSound(char[] sBuffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sCollectSound", sBuffer, iBufferLen);
	}

	public void SetPageCollectSound(const char[] sBuffer)
	{
		this.SetPropString(Prop_Data, "sf2_sCollectSound", sBuffer);
	}

	property int PageCollectSoundPitch
	{
		public get() { this.GetProp(Prop_Data, "sf2_iCollectSoundPitch"); }
		public set(int value) { this.SetProp(Prop_Data, "sf2_iCollectSoundPitch", value); }
	}

	public static void Initialize()
	{
		Initialize();
	}
}

static void Initialize()
{
	g_entityFactory = new CEntityFactory("sf2_info_page_spawn", OnCreate);
	g_entityFactory.DeriveFromBaseEntity(true);

	g_entityFactory.BeginDataMapDesc()
		.DefineStringField("sf2_sModel", _, "model")
		.DefineIntField("sf2_iSkin", _, "skin")
		.DefineIntField("sf2_iBodyGroup", _, "setbodygroup")
		.DefineFloatField("sf2_flModelScale", _, "modelscale")
		.DefineStringField("sf2_sGroup", _, "group")
		.DefineStringField("sf2_sAnimation", _, "animation")
		.DefineStringField("sf2_sCollectSound", _, "collectsound")
		.DefineIntField("sf2_iCollectSoundPitch", _, "collectsoundpitch")
	.EndDataMapDesc();

	g_entityFactory.Install();
}

static void OnCreate(int iEntity)
{
	SF2PageSpawnEntity thisEnt = SF2PageSpawnEntity(iEntity);
	thisEnt.SetPageModel(PAGE_MODEL);
	thisEnt.PageSkin = -1;
	thisEnt.PageBodygroup = 0;
	thisEnt.PageModelScale = 1.0;
	thisEnt.SetPageGroup("");
	thisEnt.SetPageAnimation("");
	thisEnt.SetPageCollectSound("");
	thisEnt.PageCollectSoundPitch = 0;
	thisEnt.SetRenderColor(255, 255, 255, 255);

	SDKHook(iEntity, SDKHook_SpawnPost, OnSpawn);
}

static void OnSpawn(int iEntity) 
{
	SF2PageSpawnEntity thisEnt = SF2PageSpawnEntity(iEntity);

	char sBuffer[PLATFORM_MAX_PATH];

	thisEnt.GetPageModel(sBuffer, sizeof(sBuffer));
	if (sBuffer[0])
	{
		PrecacheModel(sBuffer);
	}

	thisEnt.GetPageCollectSound(sBuffer, sizeof(sBuffer));
	if (sBuffer[0])
	{
		PrecacheSound(sBuffer);
	}
}