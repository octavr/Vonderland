Shader "uSE/Simple tessellation" { 
	Properties { 
[Header (Tessellation config)]		_TessMultiplier_("Polygons multiplier", float) = 24
		_Displacement_("Displacement", float) = 0.15
		[Header (Textures and Bumpmaps)]_Texture("Texture", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_DispMap("DispMap", 2D) = "white" {}
	}
	SubShader {
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
		#pragma surface surf Standard vertex:vert tessellate:tess 
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"

		sampler2D _Texture;
		sampler2D _Normal;
		sampler2D _DispMap;
		float _TessMultiplier_;
		float _Displacement_;
		uniform float4 _DispMap_ST;
		float4 _p0_pi0_nc0_o3;
		float3 _p0_pi0_nc0_o4;
		float _p0_pi0_nc0_o5;
		float3 _p0_pi0_nc0_o6;
		float4 _p0_pi0_nc1_o3;
		float3 _p0_pi0_nc1_o4;
		float _p0_pi0_nc1_o5;
		float3 _p0_pi0_nc1_o6;
		float4 _p0_pi2_nc1_o3;
		float3 _p0_pi2_nc1_o4;
		float _p0_pi2_nc1_o5;
		float3 _p0_pi2_nc1_o6;

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
			float2 uv_Normal;
			float2 uv_DispMap;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;

			INTERNAL_DATA
		};

		float4 tess (appdata v0, appdata v1, appdata v2) {
			float minDist = 10.0;
			float maxDist = 25.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _TessMultiplier_);

		}

		void vert (inout appdata v){
			_p0_pi2_nc1_o3 = tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f);
			_p0_pi2_nc1_o4 = tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f).rgb;
			_p0_pi2_nc1_o5 = tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f).a;
			_p0_pi2_nc1_o6 = UnpackNormal(tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f));
			float disp = (_p0_pi2_nc1_o3).r * _Displacement_;
			v.vertex.xyz += v.normal * disp;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_p0_pi0_nc0_o3 = tex2D(_Texture, IN.uv_Texture);
			_p0_pi0_nc0_o4 = tex2D(_Texture, IN.uv_Texture).rgb;
			_p0_pi0_nc0_o5 = tex2D(_Texture, IN.uv_Texture).a;
			_p0_pi0_nc0_o6 = UnpackNormal(tex2D(_Texture, IN.uv_Texture));
			_p0_pi0_nc1_o3 = tex2D(_Normal, IN.uv_Texture);
			_p0_pi0_nc1_o4 = tex2D(_Normal, IN.uv_Texture).rgb;
			_p0_pi0_nc1_o5 = tex2D(_Normal, IN.uv_Texture).a;
			_p0_pi0_nc1_o6 = UnpackNormal(tex2D(_Normal, IN.uv_Texture));
			o.Albedo = _p0_pi0_nc0_o4;
			o.Normal = _p0_pi0_nc1_o6;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
