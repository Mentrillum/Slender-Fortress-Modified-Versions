// sf2_info_page_spawn

static CEntityFactory g_EntityFactory;

/**
 *	Interface that exposes public methods for interacting with the entity.
 */
methodmap SF2PageSpawnEntity < CBaseEntity
{
	public SF2PageSpawnEntity(int entIndex) { return view_as<SF2PageSpawnEntity>(SF2MapEntity(entIndex)); }

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_EntityFactory;
	}

	public void GetPageModel(char[] buffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sModel", buffer, iBufferLen);
	}

	public void SetPageModel(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_sModel", buffer);
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

	public void GetPageGroup(char[] buffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sGroup", buffer, iBufferLen);
	}

	public void SetPageGroup(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_sGroup", buffer);
	}

	public void GetPageAnimation(char[] buffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sAnimation", buffer, iBufferLen);
	}

	public void SetPageAnimation(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_sAnimation", buffer);
	}

	public void GetPageCollectSound(char[] buffer, int iBufferLen)
	{
		this.GetPropString(Prop_Data, "sf2_sCollectSound", buffer, iBufferLen);
	}

	public void SetPageCollectSound(const char[] buffer)
	{
		this.SetPropString(Prop_Data, "sf2_sCollectSound", buffer);
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
	g_EntityFactory = new CEntityFactory("sf2_info_page_spawn", OnCreate);
	g_EntityFactory.DeriveFromBaseEntity(true);

	g_EntityFactory.BeginDataMapDesc()
		.DefineStringField("sf2_sModel", _, "model")
		.DefineIntField("sf2_iSkin", _, "skin")
		.DefineIntField("sf2_iBodyGroup", _, "setbodygroup")
		.DefineFloatField("sf2_flModelScale", _, "modelscale")
		.DefineStringField("sf2_sGroup", _, "group")
		.DefineStringField("sf2_sAnimation", _, "animation")
		.DefineStringField("sf2_sCollectSound", _, "collectsound")
		.DefineIntField("sf2_iCollectSoundPitch", _, "collectsoundpitch")
	.EndDataMapDesc();

	g_EntityFactory.Install();
}

static void OnCreate(int entity)
{
	SF2PageSpawnEntity thisEnt = SF2PageSpawnEntity(entity);
	thisEnt.SetPageModel(PAGE_MODEL);
	thisEnt.PageSkin = -1;
	thisEnt.PageBodygroup = 0;
	thisEnt.PageModelScale = 1.0;
	thisEnt.SetPageGroup("");
	thisEnt.SetPageAnimation("");
	thisEnt.SetPageCollectSound("");
	thisEnt.PageCollectSoundPitch = 0;
	thisEnt.SetRenderColor(255, 255, 255, 255);

	SDKHook(entity, SDKHook_SpawnPost, OnSpawn);
}

static void OnSpawn(int entity)
{
	SF2PageSpawnEntity thisEnt = SF2PageSpawnEntity(entity);

	char buffer[PLATFORM_MAX_PATH];

	thisEnt.GetPageModel(buffer, sizeof(buffer));
	if (buffer[0])
	{
		PrecacheModel(buffer);
	}

	thisEnt.GetPageCollectSound(buffer, sizeof(buffer));
	if (buffer[0])
	{
		PrecacheSound(buffer);
	}
}