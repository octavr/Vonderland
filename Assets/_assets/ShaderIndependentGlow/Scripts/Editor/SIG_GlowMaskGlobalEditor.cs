using UnityEngine;
using System;
using System.Collections;
using UnityEditor;

[CustomEditor( typeof(SIG_GlowMask_Global))]
public class SIG_GlowMaskGlobalEditor : Editor {


	private Renderer rend;


	public override void OnInspectorGUI()
	{
		serializedObject.Update();

		SIG_GlowMask_Global gmask = (SIG_GlowMask_Global)target;

		if (gmask.glowMasks == null)
		{
			gmask.glowMasks = new SIG_GlowMask_Global.TextureInfo[0];
		}


		for (int i = 0; i < gmask.glowMasks.Length; i++)
		{
			EditorGUILayout.BeginVertical("box");

			EditorGUILayout.HelpBox("Array index: " + i.ToString(),MessageType.None);

			gmask.glowMasks[i].material = (Material)EditorGUILayout.ObjectField("Material", gmask.glowMasks[i].material, typeof(Material), false);

			gmask.glowMasks[i].glowTint = EditorGUILayout.ColorField("Glow tint", gmask.glowMasks[i].glowTint);

			gmask.glowMasks[i].texture = (Texture)EditorGUILayout.ObjectField("Glow mask texture", gmask.glowMasks[i].texture, typeof(Texture), false);

			if (!(gmask.glowMasks[i].useMainTextureTilingOffset = EditorGUILayout.ToggleLeft("Use main texture tiling & offset settings",gmask.glowMasks[i].useMainTextureTilingOffset)))
			{
				gmask.glowMasks[i].tiling = EditorGUILayout.Vector2Field("Tiling",gmask.glowMasks[i].tiling);
				gmask.glowMasks[i].offset = EditorGUILayout.Vector2Field("Offset",gmask.glowMasks[i].offset);
			}
			if(GUILayout.Button("Delete material slot"))
			{
				if (gmask.glowMasks[i].material == null || EditorUtility.DisplayDialog("Really delete material slot?",
														                                 "All glow parameters for material '"+ gmask.glowMasks[i].material.name +"' will be lost. Proceed?",
														                                 "Delete", "Cancel"))
				{
					for (int x = i+1; x < gmask.glowMasks.Length; x++)
						gmask.glowMasks[x-1] = gmask.glowMasks[x];			
					Array.Resize(ref gmask.glowMasks,gmask.glowMasks.Length - 1);
				}
			}

			EditorGUILayout.EndVertical();
		}

		if(GUILayout.Button("Add material slot"))
		{
			Array.Resize(ref gmask.glowMasks,gmask.glowMasks.Length + 1);
			gmask.glowMasks[gmask.glowMasks.Length-1] = new SIG_GlowMask_Global.TextureInfo();
			gmask.glowMasks[gmask.glowMasks.Length-1].glowMaskComponent = gmask;
		}

		if (GUI.changed)
			EditorUtility.SetDirty (target);
				

	}
}
