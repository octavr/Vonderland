Shader "uSE/Simple Vertex animation" { 
	Properties { 
[Header (Tessellation config)]		_TessMultiplier_("Polygons multiplier", float) = 24
		_Displacement_("Displacement", float) = -0.15
		[Header (Textures and Bumpmaps)]_DispMap("DispMap", 2D) = "white" {}
		[Header (CubeMaps)]_Cubmap("Cubmap", CUBE) = "" {}
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
		#pragma surface surf Lambert vertex:vert tessellate:tess 
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"

		sampler2D _DispMap;
		samplerCUBE _Cubmap;
		float _TessMultiplier_;
		float _Displacement_;
		uniform float4 _DispMap_ST;
		float4 _p0_pi0_nc1_o4;
		float3 _p0_pi0_nc1_o5;
		float _p0_pi0_nc1_o6;
		float _p0_pi0_nc2_o0;
		float3 _p0_pi0_nc3_o2;
		float4 _p0_pi0_nc7_o0;
		float3 _p0_pi0_nc7_o1;
		float _p0_pi0_nc7_o2;
		float _p0_pi2_nc1_o0;
		float4 _p0_pi2_nc4_o3;
		float3 _p0_pi2_nc4_o4;
		float _p0_pi2_nc4_o5;
		float3 _p0_pi2_nc4_o6;
		float2 _p0_pi2_nc12_o2;
		float4 _p0_pi2_nc17_o0;
		float2 _p0_pi2_nc17_o1;
		float _p0_pi2_nc19_o0;
		float _p0_pi2_nc21_o2;
		float _p0_pi2_nc22_o0;

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
			_p0_pi2_nc1_o0 = 15;
			_p0_pi2_nc17_o1 = v.texcoord.xy;
			_p0_pi2_nc22_o0 = 0.02;
			_p0_pi2_nc19_o0 = _Time.y;
			_p0_pi2_nc21_o2 = (_p0_pi2_nc19_o0 * _p0_pi2_nc22_o0);
			_p0_pi2_nc12_o2 = (_p0_pi2_nc17_o1 + _p0_pi2_nc21_o2);
			_p0_pi2_nc17_o0 = v.texcoord;
			_p0_pi2_nc4_o4 = tex2Dlod(_DispMap, float4((_p0_pi2_nc12_o2).x, (_p0_pi2_nc12_o2).y, 1.0f, 0.0f) * _p0_pi2_nc1_o0).rgb;
			_p0_pi2_nc4_o3 = tex2Dlod(_DispMap, float4((_p0_pi2_nc12_o2).x, (_p0_pi2_nc12_o2).y, 1.0f, 0.0f) * _p0_pi2_nc1_o0);
			_p0_pi2_nc4_o5 = tex2Dlod(_DispMap, float4((_p0_pi2_nc12_o2).x, (_p0_pi2_nc12_o2).y, 1.0f, 0.0f) * _p0_pi2_nc1_o0).a;
			_p0_pi2_nc4_o6 = UnpackNormal(tex2Dlod(_DispMap, float4((_p0_pi2_nc12_o2).x, (_p0_pi2_nc12_o2).y, 1.0f, 0.0f) * _p0_pi2_nc1_o0));
			float disp = (_p0_pi2_nc4_o3).r * _Displacement_;
			v.vertex.xyz += v.normal * disp;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			_p0_pi0_nc1_o4 = texCUBE(_Cubmap, float4(IN.worldRefl, 1.0f));
			_p0_pi0_nc1_o5 = texCUBE(_Cubmap, float4(IN.worldRefl, 1.0f)).rgb;
			_p0_pi0_nc1_o6 = texCUBE(_Cubmap, float4(IN.worldRefl, 1.0f)).a;
			_p0_pi0_nc2_o0 = 10;
			_p0_pi0_nc3_o2 = pow(_p0_pi0_nc1_o5, _p0_pi0_nc2_o0);
			_p0_pi0_nc7_o0 = float4(0.6397059, 0.1975562, 0.1975562, 1);
			_p0_pi0_nc7_o1 = float4(0.6397059, 0.1975562, 0.1975562, 1).rgb;
			_p0_pi0_nc7_o2 = float4(0.6397059, 0.1975562, 0.1975562, 1).a;
			o.Emission = _p0_pi0_nc3_o2;
			o.Albedo = _p0_pi0_nc7_o1;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
