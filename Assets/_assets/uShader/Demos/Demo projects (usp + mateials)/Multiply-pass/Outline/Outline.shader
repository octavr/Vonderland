Shader "uSE\Outline" { 
	Properties { 
[Header (Tessellation config)]		_Displacement_("Displacement", float) = 0.02
		[Header (Textures and Bumpmaps)]_Texture("Texture", 2D) = "white" {}
		[Header (Colors)]_Outlinetint("Outline tint", Color) = (0.2205882,0.2205882,0.2205882,1)
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Background+10"
			"RenderType" = "Opaque"
		}

		Fog {
			Mode Global
			Density 0
			Color (1, 1, 1, 1) 
			Range 0, 300
		}

		Stencil {
			Ref 0
			Comp Always
			Pass Keep
			Fail Keep
			ZFail Keep
		}

		Cull Off
		ZWrite  Off
		Lighting   Off
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf BlinnPhong vertex:vert 
		#include "UnityCG.cginc"

		sampler2D _Texture;
		float4 _Outlinetint;
		float _Displacement_;
		uniform float4 _DispMap_ST;
		float3 _p0_pi0_nc2_o1;

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
			float disp = (float4(1.0f, 1.0f, 1.0f, 1.0f)).r * _Displacement_;
			v.vertex.xyz += v.normal * disp;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			_p0_pi0_nc2_o1 = _Outlinetint.rgb;
			o.Albedo = _p0_pi0_nc2_o1;
		}
		ENDCG

		LOD 300
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		Fog {
			Mode Global
			Density 0
			Color (1, 1, 1, 1) 
			Range 0, 300
		}

		Stencil {
			Ref 0
			Comp Always
			Pass Keep
			Fail Keep
			ZFail Keep
		}

		Cull Off
		ZWrite  On
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf Standard vertex:vert 
		#include "UnityCG.cginc"

		sampler2D _Texture;
		float4 _Outlinetint;
		float3 _p1_pi0_nc8_o4;

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
			_p1_pi0_nc8_o4 = tex2D(_Texture, IN.uv_Texture).rgb;
			o.Albedo = _p1_pi0_nc8_o4;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
