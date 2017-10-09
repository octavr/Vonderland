// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "uSE/Parallax" { 
	Properties { 
		[Header (Textures and Bumpmaps)]_Main("Main", 2D) = "white" {}
		_Disp("Disp", 2D) = "white" {}
		_Normal("Normal", 2D) = "white" {}
		[Header (Variables)]_Disppower("Disp power", float) = 0.015
		_Scale("Scale", float) = 10
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
		#pragma surface surf Standard vertex:vert 
		#include "UnityCG.cginc"

		sampler2D _Main;
		sampler2D _Disp;
		sampler2D _Normal;
		float _Disppower;
		float _Scale;
		float2 _p0_pi0_nc0_o2;
		float4 _p0_pi0_nc3_o3;
		float3 _p0_pi0_nc3_o4;
		float _p0_pi0_nc3_o5;
		float3 _p0_pi0_nc3_o6;
		float _p0_pi0_nc5_o0;
		float _p0_pi0_nc7_o0;
		float4 _p0_pi0_nc8_o3;
		float3 _p0_pi0_nc8_o4;
		float _p0_pi0_nc8_o5;
		float3 _p0_pi0_nc8_o6;
		float _p0_pi0_nc10_o1;
		float _p0_pi0_nc10_o2;
		float _p0_pi0_nc10_o3;
		float2 _p0_pi0_nc12_o0;
		float4 _p0_pi0_nc14_o3;
		float3 _p0_pi0_nc14_o4;
		float _p0_pi0_nc14_o5;
		float3 _p0_pi0_nc14_o6;

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
			float2 uv_Disp;
			float2 uv_Normal;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;
			float3 parallaxCord;

			INTERNAL_DATA
		};

		float2 CalculateParallaxUV(Input IN, float disp, sampler2D displacmentMap, float2 uv){
			float height = disp * (-0.5 + tex2D(displacmentMap, uv).x); 
			float2 texCoordOffsets = clamp(height * IN.parallaxCord.xy / IN.parallaxCord.z, -0.01f, 0.01f);  
			return uv + texCoordOffsets;
		}

		void vert (inout appdata v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
			float4x4 modelMatrixInverse = unity_WorldToObject;
			float3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
			float3 viewDirInObjectCoords = mul(modelMatrixInverse, float4(_WorldSpaceCameraPos, 1.0)).xyz - v.vertex.xyz;
			float3x3 localSurface2ScaledObjectT = float3x3(v.tangent.xyz, binormal, v.normal);
			data.parallaxCord = mul(localSurface2ScaledObjectT, viewDirInObjectCoords);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_p0_pi0_nc5_o0 = _Disppower;
			_p0_pi0_nc7_o0 = _Scale;
			_p0_pi0_nc12_o0 = IN.uv_Main * _p0_pi0_nc7_o0;
			_p0_pi0_nc0_o2 = CalculateParallaxUV(IN, _p0_pi0_nc5_o0, _Disp, _p0_pi0_nc12_o0);
			_p0_pi0_nc3_o6 = UnpackNormal(tex2D(_Main, _p0_pi0_nc0_o2));
			_p0_pi0_nc3_o3 = tex2D(_Main, _p0_pi0_nc0_o2);
			_p0_pi0_nc3_o5 = tex2D(_Main, _p0_pi0_nc0_o2).a;
			_p0_pi0_nc8_o3 = tex2D(_Disp, _p0_pi0_nc12_o0);
			_p0_pi0_nc8_o4 = tex2D(_Disp, _p0_pi0_nc12_o0).rgb;
			_p0_pi0_nc8_o5 = tex2D(_Disp, _p0_pi0_nc12_o0).a;
			_p0_pi0_nc8_o6 = UnpackNormal(tex2D(_Disp, _p0_pi0_nc12_o0));
			_p0_pi0_nc10_o1 = (_p0_pi0_nc8_o4).x;
			_p0_pi0_nc10_o2 = (_p0_pi0_nc8_o4).y;
			_p0_pi0_nc10_o3 = (_p0_pi0_nc8_o4).z;
			_p0_pi0_nc3_o4 = tex2D(_Main, _p0_pi0_nc0_o2).rgb;
			_p0_pi0_nc14_o3 = tex2D(_Normal, IN.uv_Main);
			_p0_pi0_nc14_o4 = tex2D(_Normal, IN.uv_Main).rgb;
			_p0_pi0_nc14_o5 = tex2D(_Normal, IN.uv_Main).a;
			_p0_pi0_nc14_o6 = UnpackNormal(tex2D(_Normal, IN.uv_Main));
			o.Albedo = _p0_pi0_nc3_o4;
			o.Occlusion = _p0_pi0_nc10_o1;
			o.Normal = _p0_pi0_nc14_o4;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
