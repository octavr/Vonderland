Shader "uSE/Fur PBR" { 
	Properties { 
		_Cutoff_ ("Cutoff", Range(0,1)) = 0
[Header (Tessellation config)]		_TessMultiplier_("Polygons multiplier", float) = 64
		_Displacement_("Displacement", float) = 0.15
		[Header (Textures and Bumpmaps)]_Main("Main", 2D) = "white" {}
		_Specular("Specular", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		_Heightmap("Height map", 2D) = "white" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		_Smoothness("Smoothness", 2D) = "white" {}
		[Header (Colors)]_MinHM("Min HM", Color) = (0.7369999,0,0,1)
		[Header (Variables)]_SpecularPower("SpecularPower", float) = 3
		_SmoothnessPower("SmoothnessPower", float) = -0.1
		_OcclusionPower("OcclusionPower", float) = 3.29
		_Wind("Wind", float) = 0.005
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

		Cull Back
		ZWrite  On
		ColorMask   RGB

		CGPROGRAM 
		#pragma surface surf StandardSpecular vertex:vert tessellate:tess 
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"

		float _Cutoff_;
		sampler2D _Main;
		sampler2D _Specular;
		sampler2D _Normal;
		sampler2D _Heightmap;
		sampler2D _Occlusion;
		sampler2D _Smoothness;
		float4 _MinHM;
		float _SpecularPower;
		float _SmoothnessPower;
		float _OcclusionPower;
		float _Wind;
		float _TessMultiplier_;
		float _Displacement_;
		uniform float4 _DispMap_ST;
		float4 _p0_pi0_nc2_o3;
		float3 _p0_pi0_nc2_o4;
		float _p0_pi0_nc2_o5;
		float3 _p0_pi0_nc2_o6;
		float4 _p0_pi0_nc3_o3;
		float3 _p0_pi0_nc3_o4;
		float _p0_pi0_nc3_o5;
		float3 _p0_pi0_nc3_o6;
		float _p0_pi0_nc5_o0;
		float3 _p0_pi0_nc8_o2;
		float4 _p0_pi0_nc10_o3;
		float3 _p0_pi0_nc10_o4;
		float _p0_pi0_nc10_o5;
		float3 _p0_pi0_nc10_o6;
		float _p0_pi0_nc11_o2;
		float _p0_pi0_nc12_o0;
		float4 _p0_pi0_nc14_o3;
		float3 _p0_pi0_nc14_o4;
		float _p0_pi0_nc14_o5;
		float3 _p0_pi0_nc14_o6;
		float4 _p0_pi0_nc16_o3;
		float3 _p0_pi0_nc16_o4;
		float _p0_pi0_nc16_o5;
		float3 _p0_pi0_nc16_o6;
		float _p0_pi0_nc17_o2;
		float _p0_pi0_nc18_o0;
		float4 _p0_pi2_nc1_o3;
		float3 _p0_pi2_nc1_o4;
		float _p0_pi2_nc1_o5;
		float3 _p0_pi2_nc1_o6;
		float4 _p0_pi2_nc7_o0;
		float _p0_pi2_nc17_o0;
		float _p0_pi2_nc20_o0;
		float _p0_pi2_nc21_o2;
		float _p0_pi2_nc25_o1;
		float _p0_pi2_nc25_o2;
		float _p0_pi2_nc25_o3;
		float _p0_pi2_nc25_o4;
		float _p0_pi2_nc26_o2;
		float4 _p0_pi2_nc27_o4;
		float4 _p0_pi2_nc30_o4;
		float4 _p0_pi2_nc32_o0;
		float3 _p0_pi2_nc32_o1;
		float _p0_pi2_nc32_o2;
		float4 _p0_pi2_nc33_o2;

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
			float2 uv_Specular;
			float2 uv_Normal;
			float2 uv_Heightmap;
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
			_p0_pi2_nc1_o3 = tex2Dlod(_Heightmap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f);
			_p0_pi2_nc1_o4 = tex2Dlod(_Heightmap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f).rgb;
			_p0_pi2_nc1_o5 = tex2Dlod(_Heightmap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f).a;
			_p0_pi2_nc1_o6 = UnpackNormal(tex2Dlod(_Heightmap, float4(v.texcoord.x, v.texcoord.y, 1.0f, 0.0f) * 1.0f));
			_p0_pi2_nc7_o0 = v.vertex;
			_p0_pi2_nc17_o0 = _SinTime.w;
			_p0_pi2_nc20_o0 = _Wind;
			_p0_pi2_nc21_o2 = (_p0_pi2_nc17_o0 * _p0_pi2_nc20_o0);
			_p0_pi2_nc25_o1 = (_p0_pi2_nc7_o0).x;
			_p0_pi2_nc25_o2 = (_p0_pi2_nc7_o0).y;
			_p0_pi2_nc25_o3 = (_p0_pi2_nc7_o0).z;
			_p0_pi2_nc25_o4 = (_p0_pi2_nc7_o0).w;
			_p0_pi2_nc26_o2 = (_p0_pi2_nc25_o1 + _p0_pi2_nc21_o2);
			_p0_pi2_nc27_o4 = float4(_p0_pi2_nc26_o2, _p0_pi2_nc25_o2, _p0_pi2_nc25_o3, _p0_pi2_nc25_o4);
			_p0_pi2_nc32_o0 = _MinHM;
			_p0_pi2_nc33_o2 = (_p0_pi2_nc1_o3 + _p0_pi2_nc32_o0);
			_p0_pi2_nc32_o1 = _MinHM.rgb;
			_p0_pi2_nc32_o2 = _MinHM.a;
			_p0_pi2_nc30_o4 = (_p0_pi2_nc1_o3) > (_p0_pi2_nc32_o0) ? (_p0_pi2_nc1_o3) : (_p0_pi2_nc33_o2);
			float disp = (_p0_pi2_nc30_o4).r * _Displacement_;
			v.vertex.xyz += v.normal * disp;
		}

		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {
			_p0_pi0_nc2_o3 = tex2D(_Main, IN.uv_Main);
			_p0_pi0_nc2_o4 = tex2D(_Main, IN.uv_Main).rgb;
			_p0_pi0_nc2_o5 = tex2D(_Main, IN.uv_Main).a;
			_p0_pi0_nc2_o6 = UnpackNormal(tex2D(_Main, IN.uv_Main));
			_p0_pi0_nc3_o3 = tex2D(_Specular, IN.uv_Main);
			_p0_pi0_nc3_o4 = tex2D(_Specular, IN.uv_Main).rgb;
			_p0_pi0_nc3_o5 = tex2D(_Specular, IN.uv_Main).a;
			_p0_pi0_nc3_o6 = UnpackNormal(tex2D(_Specular, IN.uv_Main));
			_p0_pi0_nc5_o0 = _SpecularPower;
			_p0_pi0_nc8_o2 = _p0_pi0_nc3_o4 * _p0_pi0_nc5_o0;
			_p0_pi0_nc10_o3 = tex2D(_Smoothness, IN.uv_Main);
			_p0_pi0_nc10_o4 = tex2D(_Smoothness, IN.uv_Main).rgb;
			_p0_pi0_nc10_o5 = tex2D(_Smoothness, IN.uv_Main).a;
			_p0_pi0_nc10_o6 = UnpackNormal(tex2D(_Smoothness, IN.uv_Main));
			_p0_pi0_nc12_o0 = _SmoothnessPower;
			_p0_pi0_nc11_o2 = _p0_pi0_nc10_o5 * _p0_pi0_nc12_o0;
			_p0_pi0_nc14_o3 = tex2D(_Normal, IN.uv_Main);
			_p0_pi0_nc14_o4 = tex2D(_Normal, IN.uv_Main).rgb;
			_p0_pi0_nc14_o5 = tex2D(_Normal, IN.uv_Main).a;
			_p0_pi0_nc14_o6 = UnpackNormal(tex2D(_Normal, IN.uv_Main));
			_p0_pi0_nc16_o3 = tex2D(_Occlusion, IN.uv_Main);
			_p0_pi0_nc16_o4 = tex2D(_Occlusion, IN.uv_Main).rgb;
			_p0_pi0_nc16_o5 = tex2D(_Occlusion, IN.uv_Main).a;
			_p0_pi0_nc16_o6 = UnpackNormal(tex2D(_Occlusion, IN.uv_Main));
			_p0_pi0_nc18_o0 = _OcclusionPower;
			_p0_pi0_nc17_o2 = _p0_pi0_nc16_o5 * _p0_pi0_nc18_o0;
			o.Albedo = _p0_pi0_nc2_o4;
			o.Specular = _p0_pi0_nc8_o2;
			o.Smoothness = _p0_pi0_nc11_o2;
			o.Normal = _p0_pi0_nc14_o6;
			o.Occlusion = _p0_pi0_nc17_o2;
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
