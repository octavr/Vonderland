using UnityEngine;
using System.Collections;

[AddComponentMenu("Image Effects/Shader-Independent Glow/Shader-Independent Glow image effect")]
public class ShaderIndependentGlow : MonoBehaviour {

	public LayerMask glowLayers = (LayerMask)int.MaxValue;
	public Color globalGlowTint = Color.white;
	public float mainPower = 0.3f;
	public float blurPower = 2;
	public int blurDownsample = 1;
	public float blurSize = 5;
	public int blurIterations = 1;
	public int maskDownsample = 0;
	public DebugModes debugMode = DebugModes.normal;
	public bool checkRenderTypes = true;


	private Shader glowShader;
	private Shader glowShader_ortho;
	private Shader glowShaderRT;
	private Shader glowShaderRT_ortho;

	private Material curBlurMaterial;
	private Material curComposeMaterial;

	private RenderTexture glowRT;
	private RenderTexture blurRT;

	private Camera glowCamera;
	private Camera mainCam;

	private Texture2D globalTex;

	public enum DebugModes
	{
		normal = 0,
		show_glow_mask = 1,
		show_blurred_mask = 2
	}



	Material blurMaterial 
	{
		get 
		{
			if (curBlurMaterial == null) 
			{
				curBlurMaterial = new Material(Shader.Find("Hidden/SIG_FastBlur"));
				curBlurMaterial.hideFlags = HideFlags.DontSave;
			}
			return curBlurMaterial;
		} 
	}

	Material composeMaterial 
	{
		get 
		{
			if (curComposeMaterial == null) 
			{
				curComposeMaterial = new Material(Shader.Find("Hidden/SIG_Compose"));
				curComposeMaterial.hideFlags = HideFlags.DontSave;
            }
			return curComposeMaterial;
        } 
    }


	private void Blur (RenderTexture source, RenderTexture destination)
	{
		float widthMod = 1.0f / (1.0f * (1<<blurDownsample));
		blurMaterial.SetVector("_Parameter", new Vector4(blurSize * widthMod, -blurSize * widthMod, 0.0f, 0.0f)); 
		source.filterMode = FilterMode.Bilinear;
		int rtW = source.width >> blurDownsample;
		int rtH = source.height >> blurDownsample;
		RenderTexture rt = RenderTexture.GetTemporary (rtW, rtH, 0, source.format);
		rt.filterMode = FilterMode.Bilinear; 
		Graphics.Blit (source, rt, blurMaterial, 0); 
		for(int i = 0; i < blurIterations; i++) 
		{
			float iterationOffs  = (i*1.0f);
			blurMaterial.SetVector ("_Parameter", new Vector4 (blurSize * widthMod + iterationOffs, -blurSize * widthMod - iterationOffs, 0.0f, 0.0f));
			
			// vertical blur
			RenderTexture rt2  = RenderTexture.GetTemporary (rtW, rtH, 0, source.format);
			rt2.filterMode = FilterMode.Bilinear;
			Graphics.Blit (rt, rt2, blurMaterial, 1);
			RenderTexture.ReleaseTemporary (rt);
			rt = rt2;
			
			// horizontal blur
			rt2 = RenderTexture.GetTemporary (rtW, rtH, 0, source.format);
			rt2.filterMode = FilterMode.Bilinear;
			Graphics.Blit (rt, rt2, blurMaterial, 2);
			RenderTexture.ReleaseTemporary (rt);
			rt = rt2;
		}
		Graphics.Blit (rt, destination);
		RenderTexture.ReleaseTemporary (rt);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) 
	{		
		glowCamera.CopyFrom(mainCam);
		glowCamera.rect = new Rect(0,0,1,1);
		glowCamera.cullingMask = glowLayers;
		glowCamera.backgroundColor = new Color(0,0,0,0);
		glowCamera.clearFlags = CameraClearFlags.SolidColor;
		glowCamera.depthTextureMode = DepthTextureMode.None;
		glowCamera.renderingPath = RenderingPath.VertexLit;

		glowRT = RenderTexture.GetTemporary(src.width >> maskDownsample, src.height >> maskDownsample, 24, RenderTextureFormat.ARGB32);

		glowCamera.targetTexture = glowRT;



		if (maskDownsample == 0)
			Shader.SetGlobalFloat("_SIG_ZShift",0.999f);
		else
			Shader.SetGlobalFloat("_SIG_ZShift",0.99f);

		if (glowCamera.orthographic)
		{
			if (!checkRenderTypes)
				glowCamera.RenderWithShader(glowShader_ortho,"");
			else
				glowCamera.RenderWithShader(glowShaderRT_ortho,"RenderType");
		}
		else
		{
			if (!checkRenderTypes)
				glowCamera.RenderWithShader(glowShader,"");
			else
				glowCamera.RenderWithShader(glowShaderRT,"RenderType");
		}

		blurRT = RenderTexture.GetTemporary(src.width, src.height, 0, RenderTextureFormat.ARGB32);

		Blur(glowRT,blurRT);

		composeMaterial.SetTexture("_GlowMask",glowRT);
		composeMaterial.SetTexture("_BlurMask",blurRT);
		composeMaterial.SetFloat("_GlowPower",mainPower);
		composeMaterial.SetFloat("_BlurPower",blurPower);
		composeMaterial.SetColor("_GlobalTint",globalGlowTint);

		switch (debugMode)
		{
		case DebugModes.normal:
			Graphics.Blit(src,dest,composeMaterial);
			break;
		case DebugModes.show_glow_mask:
			Graphics.Blit(glowRT,dest);
			break;
		case DebugModes.show_blurred_mask:
			Graphics.Blit(blurRT,dest);
			break;
		}

		RenderTexture.ReleaseTemporary(glowRT);
		RenderTexture.ReleaseTemporary(blurRT);
	}    

	// Use this for initialization
	void Start () 
	{
		glowShader = Shader.Find("Hidden/ShaderIndependentGlow");
		glowShader_ortho = Shader.Find("Hidden/ShaderIndependentGlow_ortho");
		glowShaderRT = Shader.Find("Hidden/ShaderIndependentGlow_RT");
		glowShaderRT_ortho = Shader.Find("Hidden/ShaderIndependentGlow_RT_ortho");
		mainCam = GetComponent<Camera>();

		GameObject obj = new GameObject("ShaderIndependentGlowCamera");
		obj.transform.parent = transform;
		obj.transform.position = transform.position;
		obj.transform.rotation = transform.rotation;
		glowCamera = obj.AddComponent<Camera>();
		glowCamera.CopyFrom(mainCam);
		/*
		glowCamera.cullingMask = glowLayers;
		glowCamera.backgroundColor = new Color(0,0,0,0);
		glowCamera.clearFlags = CameraClearFlags.Color;
		glowCamera.depthTextureMode = DepthTextureMode.None;
		*/
		glowCamera.targetTexture = glowRT;
		glowCamera.enabled = false;

		/*
		Color32 black = new Color (0,0,0,0);
		globalTex = new Texture2D(2,2);
		globalTex.SetPixel(1,1,black);
		globalTex.SetPixel(1,2,black);
		globalTex.SetPixel(2,1,black);
		globalTex.SetPixel(2,2,black);
		globalTex.Apply();

		Shader.SetGlobalTexture("_SIG_GlowMask",globalTex);
		*/
		Shader.SetGlobalFloat("_SIG_ZShift",0.01f);
    }

	void OnEnable ()
	{
		mainCam = GetComponent<Camera>();
		mainCam.depthTextureMode |= DepthTextureMode.Depth;
	}
	
	void OnDisable ()
	{
		if(curBlurMaterial != null)		
			DestroyImmediate(curBlurMaterial);
		if(curComposeMaterial != null)		
			DestroyImmediate(curComposeMaterial);
    }
}
