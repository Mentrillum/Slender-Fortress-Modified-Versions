#if defined _sf2_chasepath_included
 #endinput
#endif
#define _sf2_chasepath_included

#define MAX_PATH 32

static NavPath g_hChasePath[MAX_PATH] = { null, ... };
static int g_iPathNodeIndex[MAX_PATH];
static int g_iPathBehindNodeIndex[MAX_PATH];
static int g_iRefChasePathTarget[MAX_PATH] = { INVALID_ENT_REFERENCE, ... };
static float g_flChasePathAvoidRange[MAX_PATH];
static float g_flChasePathNodeTolerance[MAX_PATH] = { 32.0, ... };
static float g_flChasePathLookAheadDistance[MAX_PATH] = {10.0, ...};
static float g_flChasePathLastBuildTime[MAX_PATH];

static float g_vecPathMovePosition[MAX_PATH][3];
static float g_vecPathJumpGoalPosition[MAX_PATH][3];

static CNavArea g_lastKnownTargetArea[MAX_PATH] = INVALID_NAV_AREA;

methodmap ChaserPathLogic
{
	public ChaserPathLogic(int iIndex)
	{
		if (g_hChasePath[iIndex] != null) delete g_hChasePath[iIndex];
		
		g_hChasePath[iIndex] = new NavPath();
		g_iRefChasePathTarget[iIndex] = INVALID_ENT_REFERENCE;
		g_lastKnownTargetArea[iIndex] = INVALID_NAV_AREA;
		g_iPathNodeIndex[iIndex] = 0;
		g_iPathBehindNodeIndex[iIndex] = 0;
		g_flChasePathNodeTolerance[iIndex] = 32.0;
		g_flChasePathLookAheadDistance[iIndex] = 100.0;
		g_flChasePathAvoidRange[iIndex] = 100.0;
		g_flChasePathLastBuildTime[iIndex] = GetGameTime();
		return view_as<ChaserPathLogic>(iIndex);
	}
	
	property int Index
	{
		public get() { return view_as<int>(this); }
	}
	
	property int TargetRef
	{
		public get() { return g_iRefChasePathTarget[this.Index]; }
		public set(int iRef) { g_iRefChasePathTarget[this.Index] = iRef; }
	}
	
	property int Target
	{
		public get() { return EntRefToEntIndex(g_iRefChasePathTarget[this.Index]); }
		public set(int iEntity) { g_iRefChasePathTarget[this.Index] = EntIndexToEntRef(iEntity); }
	}
	
	property float flNodeDistTolerance
	{
		public get() { return g_flChasePathNodeTolerance[this.Index]; }
		public set(float flNew) { g_flChasePathNodeTolerance[this.Index] = flNew; }
	}
	
	property float flLookAheadDistance
	{
		public get() { return g_flChasePathLookAheadDistance[this.Index]; }
		public set(float flNew) { g_flChasePathLookAheadDistance[this.Index] = flNew; }
	}
	
	public void ClearPath()
	{
		g_hChasePath[this.Index].Clear();
		g_iRefChasePathTarget[this.Index] = INVALID_ENT_REFERENCE;
		g_lastKnownTargetArea[this.Index] = INVALID_NAV_AREA;
		g_iPathNodeIndex[this.Index] = 0;
		g_iPathBehindNodeIndex[this.Index] = 0;
	}
	
	public bool IsPathValid()
	{
		return g_hChasePath[this.Index].IsValid();
	}
	
	public void GetGoalPosition(float buffer[3])
	{
		g_hChasePath[this.Index].GetNodePosition(g_hChasePath[this.Index].Length-1, buffer);
	}
	
	public void GetJumpGoalPosition(float buffer[3])
	{
		buffer = g_vecPathJumpGoalPosition[this.Index];
	}
	
	public int GetTotalNode()
	{
		return g_hChasePath[this.Index].Length;
	}
	
	public void GetMovePosition(float buffer[3])
	{
		buffer = g_vecPathMovePosition[this.Index];
	}
	
	public CNavArea GetMovePositionNavArea()
	{
		int pathNodeIndex = g_iPathNodeIndex[this.Index];
		if (pathNodeIndex < 0 || pathNodeIndex >= this.GetTotalNode())
		{
			return INVALID_NAV_AREA;
		}
		return g_hChasePath[this.Index].GetNodeArea(pathNodeIndex);
	}
	
	public bool IsRepathNeeded(CNavArea bAreaCheck = INVALID_NAV_AREA)
	{
		if (!g_hChasePath[this.Index].Length) return true;
		
		if (bAreaCheck != INVALID_NAV_AREA)
		{
			if (g_lastKnownTargetArea[this.Index] == bAreaCheck)
				return false;
			else
				return true;
		}
		
		if (this.TargetRef != INVALID_ENT_REFERENCE)
		{
			int iTarget = this.Target;
			if (iTarget <= 0 || iTarget > 2048)
				return true;
			CNavArea currentTargetArea = SDK_GetLastKnownArea(iTarget);
			if (currentTargetArea != g_lastKnownTargetArea[this.Index])
				return true;
			return false;
		}
		return true;//This should never ever be reached
	}
	
	public bool ComputePath(int iEntity, int iTarget, NavPathCostFunctor costFunction, any costData, bool populateIfIncomplete = true, CNavArea &closestAreaIndex = INVALID_NAV_AREA)
	{
		if (g_flChasePathLastBuildTime[this.Index] > GetGameTime()) return false;
		
		this.ClearPath();
		
		CNavArea currentTargetArea = SDK_GetLastKnownArea(iTarget);
		CNavArea startarea = SDK_GetLastKnownArea(iEntity);
		if (currentTargetArea != INVALID_NAV_AREA)
		{
			this.Target = iTarget;
			float vecStartPos[3], vecGoalPos[3];
			GetEntPropVector(iEntity, Prop_Data, "m_vecAbsOrigin", vecStartPos);
			GetEntPropVector(iTarget, Prop_Data, "m_vecAbsOrigin", vecGoalPos);
			
			if (this.IsRepathNeeded())
			{
				//The target changed area repath required
				if (!g_hChasePath[this.Index].ConstructPathFromPoints(vecStartPos, vecGoalPos, 0.0, costFunction, costData, populateIfIncomplete, closestAreaIndex, startarea, currentTargetArea) && !populateIfIncomplete)
				{
					g_hChasePath[this.Index].Clear();
					g_lastKnownTargetArea[this.Index] = currentTargetArea;
					g_flChasePathLastBuildTime[this.Index] = GetGameTime()+0.3;
					return false;//Failed to build our path
				}
				g_iPathNodeIndex[this.Index] = 1;
				g_iPathBehindNodeIndex[this.Index] = 0;
				g_lastKnownTargetArea[this.Index] = currentTargetArea;
				g_flChasePathLastBuildTime[this.Index] = GetGameTime()+0.3;
				return true;
			}
			
			//The target might not have moved but is still in same area, update our goal position.
			vecGoalPos[2] = currentTargetArea.GetZ(vecGoalPos);
			g_hChasePath[this.Index].SetNodePosition(g_hChasePath[this.Index].Length-1, vecGoalPos);
			return true;
		}
		return false;
	}
	
	public bool ComputePathToPos(int iEntity, float vecEndPos[3], NavPathCostFunctor costFunction, any costData, bool populateIfIncomplete = true, CNavArea &closestAreaIndex = INVALID_NAV_AREA)
	{
		if (g_flChasePathLastBuildTime[this.Index] > GetGameTime()) return false;
		
		this.ClearPath();
		
		CNavArea startArea = SDK_GetLastKnownArea(iEntity);
		if (startArea != INVALID_NAV_AREA)
		{
			CNavArea endArea = NavMesh_GetNearestArea(vecEndPos, _, 50.0);
			if (this.IsRepathNeeded(endArea))
			{
				float vecStartPos[3];
				GetEntPropVector(iEntity, Prop_Data, "m_vecAbsOrigin", vecStartPos);
				if (!g_hChasePath[this.Index].ConstructPathFromPoints(vecStartPos, vecEndPos, 50.0, costFunction, costData, populateIfIncomplete, closestAreaIndex, startArea, endArea) && !populateIfIncomplete)
				{
					g_hChasePath[this.Index].Clear();
					return false;
				}
				g_iPathNodeIndex[this.Index] = 1;
				g_iPathBehindNodeIndex[this.Index] = 0;
				g_lastKnownTargetArea[this.Index] = endArea;
				g_flChasePathLastBuildTime[this.Index] = GetGameTime()+0.3;
				return true;
			}
			//The target might not have moved but is still in same area, update our goal position.
			vecEndPos[2] = endArea.GetZ(vecEndPos);
			g_hChasePath[this.Index].SetNodePosition(g_hChasePath[this.Index].Length-1, vecEndPos);
			return true;
		}
		return false;
	}
	
	public bool ComputePathFromPosToPos(float vecStartPos[3], float vecEndPos[3], NavPathCostFunctor costFunction, any costData, bool populateIfIncomplete = true, CNavArea &closestAreaIndex = view_as<CNavArea>(0))
	{
		if (g_flChasePathLastBuildTime[this.Index] > GetGameTime()) return false;
		
		this.ClearPath();
		
		CNavArea startArea = NavMesh_GetNearestArea(vecStartPos, _, 50.0);
		if (startArea != INVALID_NAV_AREA)
		{
			CNavArea endArea = NavMesh_GetNearestArea(vecEndPos, _, 50.0);
			if (!g_hChasePath[this.Index].ConstructPathFromPoints(vecStartPos, vecEndPos, 50.0, costFunction, costData, populateIfIncomplete, closestAreaIndex, startArea, endArea) && !populateIfIncomplete)
			{
				g_hChasePath[this.Index].Clear();
				return false;
			}
			g_iPathNodeIndex[this.Index] = 1;
			g_iPathBehindNodeIndex[this.Index] = 0;
			g_lastKnownTargetArea[this.Index] = endArea;
			g_flChasePathLastBuildTime[this.Index] = GetGameTime()+0.3;
			return true;
		}
		return false;
	}
	
	public void Jump(NextBotGroundLocomotion nextbotLocomotion, float vecStartPos[3], float vecEndPos[3])
	{
		float vecJumpVel[3];
		float flActualHeight = vecEndPos[2] - vecStartPos[2];
		float height = flActualHeight;
		if ( height < 16.0 )
		{
			height = 16.0;
		}
		
		float additionalHeight = 0.0;
		if (height < 32.0)
		{
			additionalHeight = 16.0;
		}
		float flGravity = nextbotLocomotion.GetGravity();
		
		height += additionalHeight;
		
		float speed = SquareRoot( 2.0 * flGravity * height );
		float time = (speed / flGravity);
		
		time += SquareRoot( ( 2 * additionalHeight) / flGravity );
		
		SubtractVectors( vecEndPos, vecStartPos, vecJumpVel );
		vecJumpVel[0] /= time;
		vecJumpVel[1] /= time;
		vecJumpVel[2] /= time;
		
		vecJumpVel[2] = speed;
		
		float flJumpSpeed = GetVectorLength(vecJumpVel);
		float flMaxSpeed = 650.0;
		if ( flJumpSpeed > flMaxSpeed )
		{
			vecJumpVel[0] *= flMaxSpeed / flJumpSpeed;
			vecJumpVel[1] *= flMaxSpeed / flJumpSpeed;
			vecJumpVel[2] *= flMaxSpeed / flJumpSpeed;
		}

		nextbotLocomotion.Jump();
		nextbotLocomotion.SetVelocity(vecJumpVel);
		
		g_vecPathJumpGoalPosition[this.Index] = vecEndPos;
	}
	public int GetCurrentNodeIndex()
	{
		if (!this.IsPathValid()) return false;
		return g_iPathNodeIndex[this.Index];
	}
	public bool PathGetNodeIndexPosition(int iIndex, float vecBuffer[3])
	{
		if (!this.IsPathValid()) return false;
		NavPath hPath = g_hChasePath[this.Index];
		int iNode = iIndex;
		if (iNode < hPath.Length)
		{
			hPath.GetNodePosition(iNode, vecBuffer);
			return true;
		}
		return false;
	}
	
	public void Update(INextBot nextbot, bool bUpdateAngle = true, TraceEntityFilter fTraceFilterFunction = view_as<TraceEntityFilter>(INVALID_FUNCTION))
	{
		if (!this.IsPathValid()) return;
		NavPath hPath = g_hChasePath[this.Index];
		
		// Check if the NPC has made it to the goal.
		int pathNodeIndex = g_iPathNodeIndex[this.Index];
		if (pathNodeIndex < 0 || pathNodeIndex >= hPath.Length)
		{
			return;
		}
		float vecPathNodePos[3];
		hPath.GetNodePosition(pathNodeIndex, vecPathNodePos);
		
		NextBotGroundLocomotion nextbotLocomotion = view_as<NextBotGroundLocomotion>(nextbot.GetLocomotionInterface());
		
		float vecFeetPos[3];
		nextbotLocomotion.GetFeet(vecFeetPos);
		
		float vecCentroidPos[3];
		float vecEyePos[3] = {0.0, 0.0, 70.0};
		AddVectors(vecFeetPos, vecEyePos, vecCentroidPos);
		ScaleVector(vecCentroidPos, 0.5);
		
		if (GetVectorDistance(vecFeetPos, vecPathNodePos) < this.flNodeDistTolerance || ((-this.flNodeDistTolerance < vecPathNodePos[0]-vecFeetPos[0] < this.flNodeDistTolerance) && (-this.flNodeDistTolerance < vecPathNodePos[1]-vecFeetPos[1] < this.flNodeDistTolerance)))
		{
			g_iPathNodeIndex[this.Index] = ++pathNodeIndex;
			
			if (pathNodeIndex >= hPath.Length)
			{
				this.ClearPath();
				nextbotLocomotion.Stop();
				return;
			}
			hPath.GetNodePosition(pathNodeIndex, vecPathNodePos);
		}
		CNavLadder pathNodeLadder = hPath.GetNodeLadder(pathNodeIndex);
		if (pathNodeLadder != INVALID_NAV_LADDER)
		{
			// @TODO: Traverse ladders, maybe?
		}
		
		CopyVector(vecPathNodePos, g_vecPathMovePosition[this.Index]);
		
		int pathBehindNodeIndex = 0;
		pathNodeIndex = hPath.FindAheadPathPoint(this.flLookAheadDistance, pathNodeIndex, vecFeetPos, vecCentroidPos, vecEyePos, g_vecPathMovePosition[this.Index], pathBehindNodeIndex);
		
		// Clamp point to the path.
		if (pathNodeIndex >= hPath.Length)
		{
			pathNodeIndex = hPath.Length - 1;
		}
		
		g_iPathNodeIndex[this.Index] = pathNodeIndex;
		g_iPathBehindNodeIndex[this.Index] = pathBehindNodeIndex;
		
		// Check if we need to jump over a wall or something.
		if (!nextbotLocomotion.IsClimbingOrJumping())
		{
			float flZDiff = (g_vecPathMovePosition[this.Index][2] - vecFeetPos[2]);
		
			if (flZDiff > nextbotLocomotion.GetStepHeight())
			{
				float vecMyPos2D[3], vecGoalPos2D[3];
				vecMyPos2D = vecFeetPos;
				vecMyPos2D[2] = 0.0;
				vecGoalPos2D = g_vecPathMovePosition[this.Index];
				vecGoalPos2D[2] = 0.0;
				
				float fl2DDist = GetVectorDistance(vecMyPos2D, vecGoalPos2D);
				if (fl2DDist <= 120.0)
				{
					//Before we actually jump like freaking retards, let's check first if we aren't actually on a slope...
					bool bJump = false;
					
					float vecGoal[3], goalAng[3], forwadPos[3];
					MakeVectorFromPoints(vecFeetPos, g_vecPathMovePosition[this.Index], vecGoal);
					
					GetVectorAngles(vecGoal, goalAng);
					goalAng[0] = 0.0;
					goalAng[2] = 0.0;
					
					float vecTracePos[3];
					vecTracePos = vecFeetPos;
					vecTracePos[2] += 1.0;
					GetPositionForward(vecTracePos, goalAng, forwadPos, nextbot.GetBodyInterface().GetHullWidth()+1.0);
					
					Handle hTrace = INVALID_HANDLE;
					if (fTraceFilterFunction != view_as<TraceEntityFilter>(INVALID_FUNCTION))
					{
						
						hTrace = TR_TraceRayFilterEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint, fTraceFilterFunction, nextbot.GetEntity());
					}
					else
					{
						hTrace = TR_TraceRayEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint);
					}
					
					bool bClear = !TR_DidHit(hTrace);
					delete hTrace;
					
					if (!bClear)
					{
						
						forwadPos[2] += 18.0;
						
						hTrace = INVALID_HANDLE;
						if (fTraceFilterFunction != view_as<TraceEntityFilter>(INVALID_FUNCTION))
						{
							
							hTrace = TR_TraceRayFilterEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint, fTraceFilterFunction, nextbot.GetEntity());
						}
						else
						{
							hTrace = TR_TraceRayEx(vecTracePos, forwadPos, MASK_PLAYERSOLID, RayType_EndPoint);
						}
						
						bClear = !TR_DidHit(hTrace);
						delete hTrace;
						
						if (!bClear)//we have a wall
						{
							bJump = true;
						}
					}
					else//We have a gap ahead
					{
						bJump = true;
					}
					
					if (bJump) this.Jump(nextbotLocomotion, vecFeetPos, g_vecPathMovePosition[this.Index]);
				}
			}
		}
		
		if ((g_vecPathMovePosition[this.Index][2] - vecFeetPos[2]) > JumpCrouchHeight)
		{
			static const float jumpCloseRange = 50.0;
			
			float vTo2D[3];
			MakeVectorFromPoints(vecFeetPos, g_vecPathMovePosition[this.Index], vTo2D);
			vTo2D[2] = 0.0;
			
			if (GetVectorLength(vTo2D) < jumpCloseRange)
			{
				int pathNextNodeIndex = pathBehindNodeIndex + 1;
				if (pathBehindNodeIndex >= 0 && pathNextNodeIndex < hPath.Length)
				{
					float vNextPathNodePos[3];
					hPath.GetNodePosition(pathNextNodeIndex, vNextPathNodePos);
					
					if ((vNextPathNodePos[2] - vecFeetPos[2]) > JumpCrouchHeight)
					{
						this.ClearPath();
						nextbotLocomotion.Stop();
						return;
					}
				}
				else
				{
					this.ClearPath();
					nextbotLocomotion.Stop();
					return;
				}
			}
		}
		if (pathNodeIndex < (hPath.Length - 1))
		{
			float vecFloorNormalDir[3];
			nextbotLocomotion.GetGroundNormal(vecFloorNormalDir);
			CalculateFeelerReflexAdjustment(g_vecPathMovePosition[this.Index], vecFeetPos, vecFloorNormalDir, nextbotLocomotion.GetStepHeight(), ((nextbot.GetBodyInterface().GetHullWidth())/2.0), 100.0, g_flChasePathAvoidRange[this.Index], g_vecPathMovePosition[this.Index], _, TraceRayDontHitEntity, nextbot.GetEntity());
		}
		
		if (!nextbotLocomotion.IsClimbingOrJumping())
		{
			nextbotLocomotion.Approach(g_vecPathMovePosition[this.Index], 1.0);
			if (bUpdateAngle) nextbotLocomotion.FaceTowards(g_vecPathMovePosition[this.Index]);
		}
	}
}