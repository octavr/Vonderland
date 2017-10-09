using UnityEngine;
using System;
using System.Collections;
using UnityEditor;

[CustomEditor( typeof(SIG_GlowMask_For_Renderer))]
public class SIG_GlowMaskEditor : Editor {


	private Renderer rend;

	public void OnEnable ()
	{
		SIG_GlowMask_For_Renderer gmask = (SIG_GlowMask_For_Renderer)target;
		rend = gmask.gameObject.GetComponent<Renderer>();
	}


	public override void OnInspectorGUI()
	{
		serializedObject.Update();

		SIG_GlowMask_For_Renderer gmask = (SIG_GlowMask_For_Renderer)target;
		gmask.rend = rend;


		if (rend == null)
		{
			EditorGUILayout.HelpBox("Glow mask component should be placed on object with Renderer component present.",MessageType.Error);
			return;
		}

		if (gmask.glowMasks == null)
		{
			gmask.glowMasks = new SIG_GlowMask_For_Renderer.TextureInfo[rend.sharedMaterials.Length];
		}

		if (gmask.glowMasks.Length != rend.sharedMaterials.Length)
		{
			Array.Resize(ref gmask.glowMasks, rend.sharedMaterials.Length);
		}

		//foreach(SIG_GlowMask.TextureInfo tinfo in gmask.glowMasks)
		for (int i = 0; i < gmask.glowMasks.Length; i++)
		{
			if (gmask.glowMasks[i] == null)
				gmask.glowMasks[i] = new SIG_GlowMask_For_Renderer.TextureInfo();
			gmask.glowMasks[i].glowMaskComponent = gmask;
		}


		for (int i = 0; i < gmask.glowMasks.Length; i++)
		{
			EditorGUILayout.BeginVertical("box");
			EditorGUILayout.HelpBox("Material: " + rend.sharedMaterials[i].name,MessageType.None);

			gmask.glowMasks[i].glowTint = EditorGUILayout.ColorField("Glow tint", gmask.glowMasks[i].glowTint);

			gmask.glowMasks[i].texture = (Texture)EditorGUILayout.ObjectField("Glow mask texture", gmask.glowMasks[i].texture, typeof(Texture), false);

			if (!(gmask.glowMasks[i].useMainTextureTilingOffset = EditorGUILayout.ToggleLeft("Use main texture tiling & offset settings",gmask.glowMasks[i].useMainTextureTilingOffset)))
			{
				gmask.glowMasks[i].tiling = EditorGUILayout.Vector2Field("Tiling",gmask.glowMasks[i].tiling);
				gmask.glowMasks[i].offset = EditorGUILayout.Vector2Field("Offset",gmask.glowMasks[i].offset);
			}
			if (Application.isPlaying)
			{
				EditorGUILayout.ToggleLeft("Affect all instances of material(Read-only in Play mode)",gmask.glowMasks[i].affectAllInstancesOfMaterial);
			}
			else
			{
				gmask.glowMasks[i].affectAllInstancesOfMaterial = EditorGUILayout.ToggleLeft("Affect all instances of material",gmask.glowMasks[i].affectAllInstancesOfMaterial);
			}
			EditorGUILayout.EndVertical();
		}
		
		if (GUI.changed)
			EditorUtility.SetDirty (target);
	}
}
