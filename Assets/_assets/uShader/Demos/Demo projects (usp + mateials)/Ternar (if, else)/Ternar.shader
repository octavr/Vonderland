Shader "uSE/Ternar" { 
	Properties { 
		_Cutoff_ ("Cutoff", Range(0,1)) = 0
		[Header (Textures and Bumpmaps)]_Texture("Texture", 2D) = "white" {}
		[Header (Variables)]_Separator("Separator", float) = 0.5
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		Cull Off
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf Standard vertex:vert 
		#include "UnityCG.cginc"

		float _Cutoff_;
		sampler2D _Texture;
		float _Separator;

		struct appdata{
			float4 vertex    : POSITION;  // The vertex position in model space.
			float3 normal    : NORMAL;    // The vertex normal in model space.
			float4 texcoord  : TEXCOORD0; // The first UV coordinate.
			float4 texcoord1 : TEXCOORD1; // The second UV coordinate.
			float4 texcoord2 : TEXCOORD2; // The third UV coordinate.
			float4 tangent   : TANGENT;   // The tangent vector in Model Space (used for normal mapping).
			float4 color     : COLOR;     // Per-vertex color.
		};

		struct Input{
			float2 uv_Texture;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;

			INTERNAL_DATA
		};

		void vert (inout appdata v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			o.Albedo = ((tex2D(_Texture, IN.uv_Texture).rgb).y) >= (_Separator) ? (float4(0.07839534, 0.1881115, 0.3676471, 1).rgb) : (float4(0.875, 0.7720588, 0.8295639, 1).rgb);
			o.Metallic = 0.5;
			o.Smoothness = 0.5;
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
