#pragma semicolon 1
#pragma newdecls required

static const char g_Classname[] = "sf2_point_spotlight";

static CEntityFactory g_Factory;

methodmap SF2PointSpotlightEntity < CBaseEntity
{
	public SF2PointSpotlightEntity(int entIndex)
	{
		return view_as<SF2PointSpotlightEntity>(CBaseEntity(entIndex));
	}

	public bool IsValid()
	{
		if (!CBaseEntity(this.index).IsValid())
		{
			return false;
		}

		return CEntityFactory.GetFactoryOfEntity(this.index) == g_Factory;
	}

	public static void Initialize()
	{
		g_Factory = new CEntityFactory(g_Classname, OnCreate, OnRemove);
		g_Factory.DeriveFromClass("env_beam");
		g_Factory.BeginDataMapDesc()
			.DefineEntityField("m_Start")
			.DefineEntityField("m_End")
			.DefineFloatField("m_HaloScale")
			.DefineIntField("m_Brightness")
			.DefineFloatField("m_Distance")
			.DefineFloatField("m_SpotlightRadius")
			.DefineIntField("m_Cone")
			.DefineBoolField("m_IsOn")
			.DefineFloatField("m_Length")
			.DefineInputFunc("LightOn", InputFuncValueType_Void, InputLightOn)
			.DefineInputFunc("LightOff", InputFuncValueType_Void, InputLightOff)
			.EndDataMapDesc();
		g_Factory.Install();
	}

	property CBaseEntity Start
	{
		public get()
		{
			return CBaseEntity(this.GetPropEnt(Prop_Data, "m_Start"));
		}

		public set(CBaseEntity value)
		{
			this.SetPropEnt(Prop_Data, "m_Start", value.index);
		}
	}

	property CBaseEntity End
	{
		public get()
		{
			return CBaseEntity(this.GetPropEnt(Prop_Data, "m_End"));
		}

		public set(CBaseEntity value)
		{
			this.SetPropEnt(Prop_Data, "m_End", value.index);
		}
	}

	property float HaloScale
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_HaloScale");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_HaloScale", value);
		}
	}

	property int Brightness
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_Brightness");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_Brightness", value);
		}
	}

	property float Distance
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_Distance");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_Distance", value);
		}
	}

	property float SpotlightRadius
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_SpotlightRadius");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_SpotlightRadius", value);
		}
	}

	property int Cone
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_Cone");
		}

		public set(int value)
		{
			this.SetProp(Prop_Data, "m_Cone", value);
		}
	}

	property bool IsOn
	{
		public get()
		{
			return this.GetProp(Prop_Data, "m_IsOn") != 0;
		}

		public set(bool value)
		{
			this.SetProp(Prop_Data, "m_IsOn", value);
		}
	}

	property float Length
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_Length");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_Length", value);
		}
	}

	property float Width
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_fWidth");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_fWidth", value);
		}
	}

	property float EndWidth
	{
		public get()
		{
			return this.GetPropFloat(Prop_Data, "m_fEndWidth");
		}

		public set(float value)
		{
			this.SetPropFloat(Prop_Data, "m_fEndWidth", value);
		}
	}

	public void TurnOn()
	{
		if (this.IsOn)
		{
			return;
		}

		this.IsOn = true;

		this.AcceptInput("TurnOn");
		this.End.AcceptInput("TurnOn");
	}

	public void TurnOff()
	{
		if (!this.IsOn)
		{
			return;
		}

		this.IsOn = false;

		this.AcceptInput("TurnOff");
		this.End.AcceptInput("TurnOff");
	}

	public void SetLightSettings()
	{
		SetVariantInt(this.Brightness);
		this.End.AcceptInput("Brightness");
		SetVariantFloat(this.Distance);
		this.End.AcceptInput("Distance");
		SetVariantFloat(this.SpotlightRadius);
		this.End.AcceptInput("spotlight_radius");
		SetVariantInt(this.Cone);
		this.End.AcceptInput("cone");
	}
}

static void OnCreate(SF2PointSpotlightEntity ent)
{
	ent.SetModel(SF2_FLASHLIGHT_BEAM_MATERIAL);
	ent.SetPropFloat(Prop_Data, "m_life", 0.0);

	float pos[3], ang[3];
	ent.GetAbsOrigin(pos);
	ent.GetAbsAngles(ang);

	CBaseEntity start = ent.Start = CBaseEntity(CreateEntityByName("info_target"));
	CBaseEntity end = ent.End = CBaseEntity(CreateEntityByName("light_dynamic"));

	start.SetPropString(Prop_Data, "m_iClassname", "sf2_point_spotlight_start");
	end.SetPropString(Prop_Data, "m_iClassname", "sf2_point_spotlight_end");
	start.Teleport(pos, ang);
	end.Teleport(pos, ang);
	SetVariantString("!activator");
	start.AcceptInput("SetParent", ent.index);
	SetVariantString("!activator");
	end.AcceptInput("SetParent", ent.index);
	start.Spawn();
	end.Spawn();
	end.Activate();

	SDKHook(ent.index, SDKHook_SpawnPost, OnSpawn);
}

static void OnSpawn(int entIndex)
{
	SF2PointSpotlightEntity entity = SF2PointSpotlightEntity(entIndex);

	entity.SetPropEnt(Prop_Send, "m_hAttachEntity", entity.Start.index, 0);
	entity.SetPropEnt(Prop_Send, "m_hAttachEntity", entity.End.index, 1);
	entity.SetProp(Prop_Send, "m_nNumBeamEnts", 2);
	entity.SetProp(Prop_Send, "m_nBeamType", 2);

	entity.SetPropFloat(Prop_Send, "m_fFadeLength", 12.0);
	entity.SetPropFloat(Prop_Data, "m_fEndWidth", entity.EndWidth);
	entity.SetProp(Prop_Send, "m_nHaloIndex", g_FlashlightHaloModel);
	entity.SetPropFloat(Prop_Send, "m_fHaloScale", entity.HaloScale);
	entity.SetProp(Prop_Send, "m_nBeamFlags", 0x80 | 0x200);
	entity.SetProp(Prop_Data, "m_spawnflags", 0x8000);

	entity.SetLightSettings();

	SetEntityTransmitState(entity.index, FL_EDICT_FULLCHECK);
	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, entity.index, SpotlightEffectUpdateTransmitState);
	g_DHookShouldTransmit.HookEntity(Hook_Pre, entity.index, SpotlightEffectShouldTransmit);
	SetEntityTransmitState(entity.End.index, FL_EDICT_FULLCHECK);
	g_DHookUpdateTransmitState.HookEntity(Hook_Pre, entity.End.index, SpotlightEffectUpdateTransmitState);
	g_DHookShouldTransmit.HookEntity(Hook_Pre, entity.End.index, SpotlightEffectShouldTransmit);

	RequestFrame(SpotlightThink, EnsureEntRef(entIndex));
}

static void UpdateSpotlight(SF2PointSpotlightEntity entity)
{
	CBaseEntity spotlightEnd = entity.End;
	if (spotlightEnd.IsValid())
	{
		float pos[3], dir[3];
		entity.GetAbsOrigin(pos);
		entity.GetAbsAngles(dir);
		float endPos[3];
		endPos[0] = entity.Length;
		VectorTransform(endPos, pos, dir, endPos);

		Handle trace = TR_TraceRayFilterEx(pos, endPos, MASK_SOLID_BRUSHONLY, RayType_EndPoint, Trace, entity.index);

		float hitPos[3];
		TR_GetEndPosition(hitPos, trace);
/*
		int color[4] = { 255, 0, 0, 255 };
		TE_SetupBeamPoints(pos,
		endPos,
		g_ShockwaveBeam,
		g_ShockwaveHalo,
		0,
		30,
		0.1,
		5.0,
		5.0,
		5,
		0.0,
		color,
		1);
		TE_SendToAll();
*/
		spotlightEnd.SetAbsOrigin(hitPos);
		delete trace;
	}

}

static void SpotlightThink(SF2PointSpotlightEntity entity)
{
	if (!entity.IsValid())
	{
		return;
	}

	if (entity.IsOn)
	{
		UpdateSpotlight(entity);
	}

	RequestFrame(SpotlightThink, entity);
}

static bool Trace(int entity, int mask, any data)
{
	if (entity == data)
	{
		return false;
	}
	if (SF2_ChaserEntity(entity).IsValid() || SF2_StatueEntity(entity).IsValid())
	{
		return false;
	}
	if (SF2_BasePlayer(entity).IsValid)
	{
		return false;
	}
	return true;
}

static void OnRemove(SF2PointSpotlightEntity entity)
{
	if (entity.Start.IsValid())
	{
		RemoveEntity(entity.Start.index);
	}

	if (entity.End.IsValid())
	{
		RemoveEntity(entity.End.index);
	}
}

static MRESReturn SpotlightEffectUpdateTransmitState(int entIndex, DHookReturn ret, DHookParam params)
{
	if (entIndex == -1)
	{
		return MRES_Ignored;
	}

	ret.Value = SetEntityTransmitState(entIndex, FL_EDICT_FULLCHECK);
	return MRES_Supercede;
}

static MRESReturn SpotlightEffectShouldTransmit(int entIndex, DHookReturn ret, DHookParam params)
{
	if (entIndex == -1)
	{
		return MRES_Ignored;
	}

	// We can return FL_EDICT_ALWAYS here because SetTransmit does get called if ShouldTransmit()
	// returns this.
	// https://github.com/ValveSoftware/source-sdk-2013/blob/0d8dceea4310fde5706b3ce1c70609d72a38efdf/sp/src/game/server/gameinterface.cpp#L2481
	ret.Value = FL_EDICT_ALWAYS;
	return MRES_Supercede;
}

static void InputLightOn(int entIndex, int activator, int caller)
{
	SF2PointSpotlightEntity entity = SF2PointSpotlightEntity(entIndex);
	entity.TurnOn();
}

static void InputLightOff(int entIndex, int activator, int caller)
{
	SF2PointSpotlightEntity entity = SF2PointSpotlightEntity(entIndex);
	entity.TurnOff();
}