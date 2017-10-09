Shader "uSE\Ground Tess" { 
	Properties { 
[Header (Tessellation config)]		_TessMultiplier_("Polygons multiplier", float) = 60
		_Displacement_("Displacement", float) = 0.03
		[Header (Textures and Bumpmaps)]_Main("Main", 2D) = "white" {}
		_Ramp("Ramp", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_AO("AO", 2D) = "white" {}
		_DispMap("DispMap", 2D) = "white" {}
		[Header (Colors)]_Maintint("Main tint", Color) = (1,1,1,1)
		[Header (Variables)]_Scale("Scale", float) = 10
		_Brighness("Brighness", float) = 0.6
		_AOpower("AO power", float) = 0.4
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

		sampler2D _Main;
		sampler2D _Ramp;
		sampler2D _Normal;
		sampler2D _AO;
		sampler2D _DispMap;
		float4 _Maintint;
		float _Scale;
		float _Brighness;
		float _AOpower;
		float _TessMultiplier_;
		float _Displacement_;
		uniform float4 _DispMap_ST;
		float4 _p0_pi0_nc7_o3;
		float3 _p0_pi0_nc7_o4;
		float _p0_pi0_nc7_o5;
		float3 _p0_pi0_nc7_o6;
		float _p0_pi0_nc11_o0;
		float2 _p0_pi0_nc13_o0;
		float4 _p0_pi0_nc14_o3;
		float3 _p0_pi0_nc14_o4;
		float _p0_pi0_nc14_o5;
		float3 _p0_pi0_nc14_o6;
		float4 _p0_pi0_nc18_o0;
		float3 _p0_pi0_nc18_o1;
		float _p0_pi0_nc18_o2;
		float3 _p0_pi0_nc19_o2;
		float3 _p0_pi0_nc21_o2;
		float _p0_pi0_nc22_o0;
		float4 _p0_pi0_nc26_o3;
		float3 _p0_pi0_nc26_o4;
		float _p0_pi0_nc26_o5;
		float3 _p0_pi0_nc26_o6;
		float3 _p0_pi0_nc27_o3;
		float3 _p0_pi0_nc29_o2;
		float _p0_pi0_nc30_o0;
		float4 _p0_pi1_nc2_o0;
		float _p0_pi2_nc1_o0;
		float4 _p0_pi2_nc16_o3;
		float3 _p0_pi2_nc16_o4;
		float _p0_pi2_nc16_o5;
		float3 _p0_pi2_nc16_o6;

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
			float2 uv_Main;
			float2 uv_Ramp;
			float2 uv_Normal;
			float2 uv_AO;
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
			_p0_pi2_nc1_o0 = _Scale;
			_p0_pi2_nc16_o3 = tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * _p0_pi2_nc1_o0);
			_p0_pi2_nc16_o4 = tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * _p0_pi2_nc1_o0).rgb;
			_p0_pi2_nc16_o5 = tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * _p0_pi2_nc1_o0).a;
			_p0_pi2_nc16_o6 = UnpackNormal(tex2Dlod(_DispMap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * _p0_pi2_nc1_o0));
			float disp = (_p0_pi2_nc16_o3).r * _Displacement_;
			v.vertex.xyz += v.normal * disp;
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_p0_pi0_nc11_o0 = _Scale;
			_p0_pi0_nc13_o0 = IN.uv_Main * _p0_pi0_nc11_o0;
			_p0_pi0_nc7_o5 = tex2D(_Main, _p0_pi0_nc13_o0).a;
			_p0_pi0_nc7_o6 = UnpackNormal(tex2D(_Main, _p0_pi0_nc13_o0));
			_p0_pi0_nc7_o4 = tex2D(_Main, _p0_pi0_nc13_o0).rgb;
			_p0_pi0_nc7_o3 = tex2D(_Main, _p0_pi0_nc13_o0);
			_p0_pi0_nc14_o3 = tex2D(_Normal, _p0_pi0_nc13_o0);
			_p0_pi0_nc14_o4 = tex2D(_Normal, _p0_pi0_nc13_o0).rgb;
			_p0_pi0_nc14_o5 = tex2D(_Normal, _p0_pi0_nc13_o0).a;
			_p0_pi0_nc14_o6 = UnpackNormal(tex2D(_Normal, _p0_pi0_nc13_o0));
			_p0_pi0_nc18_o0 = _Maintint;
			_p0_pi0_nc18_o1 = _Maintint.rgb;
			_p0_pi0_nc18_o2 = _Maintint.a;
			_p0_pi0_nc19_o2 = (_p0_pi0_nc18_o1 * _p0_pi0_nc7_o4);
			_p0_pi0_nc22_o0 = _Brighness;
			_p0_pi0_nc21_o2 = _p0_pi0_nc19_o2 * _p0_pi0_nc22_o0;
			_p0_pi0_nc26_o3 = tex2D(_AO, _p0_pi0_nc13_o0);
			_p0_pi0_nc26_o4 = tex2D(_AO, _p0_pi0_nc13_o0).rgb;
			_p0_pi0_nc26_o5 = tex2D(_AO, _p0_pi0_nc13_o0).a;
			_p0_pi0_nc26_o6 = UnpackNormal(tex2D(_AO, _p0_pi0_nc13_o0));
			_p0_pi0_nc29_o2 = (_p0_pi0_nc21_o2 * _p0_pi0_nc26_o4);
			_p0_pi0_nc30_o0 = _AOpower;
			_p0_pi0_nc27_o3 = lerp(_p0_pi0_nc21_o2, _p0_pi0_nc29_o2, _p0_pi0_nc30_o0);
			o.Albedo = _p0_pi0_nc27_o3;
			o.Normal = _p0_pi0_nc14_o6;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
