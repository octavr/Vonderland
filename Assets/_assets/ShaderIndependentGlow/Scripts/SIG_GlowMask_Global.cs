using UnityEngine;
using System.Collections;
using System;


[AddComponentMenu("Image Effects/Shader-Independent Glow/GlowMask global")]
public class SIG_GlowMask_Global : MonoBehaviour {
	
	
	public TextureInfo[] glowMasks;

	[System.Serializable]
	public class TextureInfo
	{
		[HideInInspector]
		[SerializeField]
		private SIG_GlowMask_Global pGlowMaskComponent;

		[HideInInspector]
		[SerializeField]
		private Material pMaterial;

		[HideInInspector]
		[SerializeField]
		private Color pGlowTint = Color.white;

		[HideInInspector]
		[SerializeField]
		private Texture pTexture;

		[HideInInspector]
		[SerializeField]
		private bool pUseMainTextureTilingOffset = true;

		[HideInInspector]
		[SerializeField]
		private Vector2 pTiling = Vector2.one;

		[HideInInspector]
		[SerializeField]
		private Vector2 pOffset = Vector2.one;

		public SIG_GlowMask_Global glowMaskComponent
		{
			get
			{
				return pGlowMaskComponent;
			}
			set
			{
				pGlowMaskComponent = value;
			}
		}

		public Material material
		{
			get
			{
				return pMaterial;
			}
			set
			{
				pMaterial = value;
				glowMaskComponent.UpdateMaskInfo();
			}
		}

		public Color glowTint
		{
			get
			{
				return pGlowTint;
			}
			set
			{
				pGlowTint = value;
				if (Application.isPlaying)
					glowMaskComponent.UpdateMaskInfo();
			}
		}

		public Texture texture
		{
			get
			{
				return pTexture;
			}
			set
			{
				pTexture = value;
				if (Application.isPlaying)
					glowMaskComponent.UpdateMaskInfo();
			}
		}

		public bool useMainTextureTilingOffset
		{
			get
			{
				return pUseMainTextureTilingOffset;
			}
			set
			{
				pUseMainTextureTilingOffset = value;
				if (Application.isPlaying)
					glowMaskComponent.UpdateMaskInfo();
			}
		}

		public Vector2 tiling
		{
			get
			{
				return pTiling;
			}
			set
			{
				pTiling = value;
				if (Application.isPlaying)
					glowMaskComponent.UpdateMaskInfo();
			}
		}


		public Vector2 offset
		{
			get
			{
				return pOffset;
			}
			set
			{
				pOffset = value;
				if (Application.isPlaying)
					glowMaskComponent.UpdateMaskInfo();
			}
		}
	}


	protected void OnDisable ()
	{
		for (int i = 0; i < glowMasks.Length; i++)
		{
			glowMasks[i].material.SetColor("_SIG_color",Color.black);
			glowMasks[i].material.SetTexture("_SIG_GlowMask", null);
		}
	}

	public void UpdateMaskInfo()
	{
		for (int i = 0; i < glowMasks.Length; i++)
		{
			if (glowMasks[i].material != null)
			{
				glowMasks[i].material.SetColor("_SIG_color",glowMasks[i].glowTint);
				glowMasks[i].material.SetTexture("_SIG_GlowMask", glowMasks[i].texture);
				if (glowMasks[i].useMainTextureTilingOffset)
				{
					glowMasks[i].material.SetTextureScale("_SIG_GlowMask", glowMasks[i].material.mainTextureScale);
					glowMasks[i].material.SetTextureOffset("_SIG_GlowMask", glowMasks[i].material.mainTextureOffset);
				}
				else
				{
					glowMasks[i].material.SetTextureScale("_SIG_GlowMask", glowMasks[i].tiling);
					glowMasks[i].material.SetTextureOffset("_SIG_GlowMask", glowMasks[i].offset);
				}
			}
		}
	}

	// Use this for initialization
	protected void Awake () 
	{
		if (glowMasks == null)
		{
			glowMasks = new TextureInfo[0];
		}

		for (int i = 0; i < glowMasks.Length; i++)
		{
			if (glowMasks[i] == null)
				glowMasks[i] = new TextureInfo();
			glowMasks[i].glowMaskComponent = this;
		}
		UpdateMaskInfo();
	}
		
}
