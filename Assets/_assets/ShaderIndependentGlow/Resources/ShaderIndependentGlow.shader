// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/ShaderIndependentGlow"
{
	Properties 
	{
		_SIG_GlowTint ("Color", Color) = (1,1,1,1)
		_SIG_GlowMask ("Glow mask(RGB)", 2D) = "white" {}
	}
	
	SubShader
	{
	    Tags { "RenderType"="Opaque" }
		ZWrite On
	    Pass 
	    {
	    Fog { Mode Off }
		CGPROGRAM		
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
								
	
		struct appdata_t 
		{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
		};	
								
		struct v2f {
			float4 pos : SV_POSITION;			
			float4 scrPos : TEXCOORD0;			
			half2 texcoord : TEXCOORD1;
		};

		sampler2D_float _CameraDepthTexture;
		
		sampler2D _SIG_GlowMask;
		float4 _SIG_GlowMask_ST;
		
		half4 _MainTex_TexelSize;
		fixed4 _SIG_color;
		float _SIG_ZShift;
		
		v2f vert (appdata_t v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos (v.vertex);		
			o.scrPos = ComputeScreenPos(o.pos);			
			o.texcoord = TRANSFORM_TEX(v.texcoord, _SIG_GlowMask);
			COMPUTE_EYEDEPTH(o.scrPos.z);
			return o;
		}		

		fixed4 frag(v2f i) : COLOR 
		{ 			
			
			float origDepth = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.scrPos)).r);
			float depth = i.scrPos.z;
			fixed4 c = (0.0,0.0,0.0,0.0);
			
			if (depth * _SIG_ZShift < origDepth)
				c = tex2D(_SIG_GlowMask, i.texcoord) * _SIG_color;
								
			return c;			
		}
		
		ENDCG
	    }
	}
}