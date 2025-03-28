#pragma semicolon 1

stock bool DispatchParticleEffect(int entity, const char[] particle, float startPos[3], float angles[3], float endPos[3],
							int attachmentPointIndex = 0, ParticleAttachment attachType = PATTACH_CUSTOMORIGIN, bool resetAllParticlesOnEntity = false)
{
	char particleReal[PLATFORM_MAX_PATH];
	FormatEx(particleReal, PLATFORM_MAX_PATH, "%s", particle);
	if (particle[0] != '\0')
	{
		int tblidx = FindStringTable("ParticleEffectNames");
		if (tblidx == INVALID_STRING_TABLE)
		{
			LogError("Could not find string table: ParticleEffectNames");
			return false;
		}
		char tmp[256];
		int count = GetStringTableNumStrings(tblidx);
		int stridx = INVALID_STRING_INDEX;
		for (int i = 0; i < count; i++)
		{
			ReadStringTable(tblidx, i, tmp, sizeof(tmp));
			if (strcmp(tmp, particleReal, false) == 0)
			{
				stridx = i;
				break;
			}
		}
		if (stridx == INVALID_STRING_INDEX)
		{
			LogError("Could not find particle: %s", particleReal);
			return false;
		}

		TE_Start("TFParticleEffect");
		TE_WriteFloat("m_vecOrigin[0]", startPos[0]);
		TE_WriteFloat("m_vecOrigin[1]", startPos[1]);
		TE_WriteFloat("m_vecOrigin[2]", startPos[2]);
		TE_WriteVector("m_vecAngles", angles);
		TE_WriteNum("m_iParticleSystemIndex", stridx);
		TE_WriteNum("entindex", entity);
		TE_WriteNum("m_iAttachType", view_as<int>(attachType));
		TE_WriteNum("m_iAttachmentPointIndex", attachmentPointIndex);
		TE_WriteNum("m_bResetParticles", resetAllParticlesOnEntity);
		TE_WriteNum("m_bControlPoint1", 0);
		TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 0);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endPos[0]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endPos[1]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endPos[2]);
		TE_SendToAll();
	}
	else
	{
		return false;
	}
	return true;
}

stock bool DispatchParticleEffectBeam(int entity, const char[] particle, float startPos[3], float angles[3], float endPos[3],
								int attachmentPointIndex = 0, ParticleAttachment attachType = PATTACH_CUSTOMORIGIN, bool resetAllParticlesOnEntity = false)
{
	char particleReal[PLATFORM_MAX_PATH];
	FormatEx(particleReal, PLATFORM_MAX_PATH, "%s", particle);
	if (particle[0] != '\0')
	{
		int tblidx = FindStringTable("ParticleEffectNames");
		if (tblidx == INVALID_STRING_TABLE)
		{
			LogError("Could not find string table: ParticleEffectNames");
			return false;
		}
		char tmp[256];
		int count = GetStringTableNumStrings(tblidx);
		int stridx = INVALID_STRING_INDEX;
		for (int i = 0; i < count; i++)
		{
			ReadStringTable(tblidx, i, tmp, sizeof(tmp));
			if (strcmp(tmp, particleReal, false) == 0)
			{
				stridx = i;
				break;
			}
		}
		if (stridx == INVALID_STRING_INDEX)
		{
			LogError("Could not find particle: %s", particleReal);
			return false;
		}

		TE_Start("TFParticleEffect");
		TE_WriteFloat("m_vecOrigin[0]", startPos[0]);
		TE_WriteFloat("m_vecOrigin[1]", startPos[1]);
		TE_WriteFloat("m_vecOrigin[2]", startPos[2]);
		TE_WriteVector("m_vecAngles", angles);
		TE_WriteNum("m_iParticleSystemIndex", stridx);
		TE_WriteNum("entindex", entity);
		TE_WriteNum("m_iAttachType", view_as<int>(attachType));
		TE_WriteNum("m_iAttachmentPointIndex", attachmentPointIndex);
		TE_WriteNum("m_bResetParticles", resetAllParticlesOnEntity);
		TE_WriteNum("m_bControlPoint1", 1);
		TE_WriteNum("m_ControlPoint1.m_eParticleAttachment", 5);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[0]", endPos[0]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[1]", endPos[1]);
		TE_WriteFloat("m_ControlPoint1.m_vecOffset[2]", endPos[2]);
		TE_SendToAll();
	}
	else
	{
		//LogError("There is no valid particle to use for effects.");
		return false;
	}
	return true;
}

float AngleNormalize(float angle)
{
	while (angle > 180.0)
	{
		angle -= 360.0;
	}
	while (angle < -180.0)
	{
		angle += 360.0;
	}
	return angle;
}

float AngleDiff(float firstAngle, float secondAngle)
{
	float diff = secondAngle - firstAngle;
	return AngleNormalize(diff);
}
