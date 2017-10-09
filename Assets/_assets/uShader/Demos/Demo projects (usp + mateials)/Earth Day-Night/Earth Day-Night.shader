Shader "uSE/Earth Day-Night v2" { 
	Properties { 
		[Header (Textures and Bumpmaps)]_Day("Day", 2D) = "white" {}
		_Night("Night", 2D) = "white" {}
		[Header (Variables)]_SmoothnessPower("SmoothnessPower", float) = 0.85
		_EmissionPower("EmissionPower", float) = 0.82
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
		#pragma surface surf StandardSpecular vertex:vert 
		#include "UnityCG.cginc"

		sampler2D _Day;
		sampler2D _Night;
		float _SmoothnessPower;
		float _EmissionPower;
		float2 _p0_pi0_nc0_o0;
		float _p0_pi0_nc8_o1;
		float _p0_pi0_nc8_o2;
		float _p0_pi0_nc12_o2;
		float2 _p0_pi0_nc13_o2;
		float4 _p0_pi0_nc14_o3;
		float3 _p0_pi0_nc14_o4;
		float _p0_pi0_nc14_o5;
		float3 _p0_pi0_nc14_o6;
		float4 _p0_pi0_nc15_o3;
		float3 _p0_pi0_nc15_o4;
		float _p0_pi0_nc15_o5;
		float3 _p0_pi0_nc15_o6;
		float3 _p0_pi0_nc16_o3;
		float _p0_pi0_nc39_o1;
		float _p0_pi0_nc58_o0;
		float _p0_pi0_nc64_o0;
		float _p0_pi0_nc67_o1;
		float3 _p0_pi0_nc70_o2;
		float _p0_pi0_nc71_o0;
		float _p0_pi0_nc72_o0;
		float _p0_pi0_nc73_o2;
		float3 _p0_pi0_nc74_o4;
		float _p0_pi0_nc75_o1;
		float _p0_pi0_nc76_o1;
		float4 _p0_pi1_nc5_o0;

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
			float2 uv_Day;
			float2 uv_Night;
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

		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {
			_p0_pi0_nc0_o0 = IN.uv_Day;
			_p0_pi0_nc8_o1 = (_p0_pi0_nc0_o0).x;
			_p0_pi0_nc8_o2 = (_p0_pi0_nc0_o0).y;
			_p0_pi0_nc64_o0 = _Time.x;
			_p0_pi0_nc12_o2 = (_p0_pi0_nc8_o1 + _p0_pi0_nc64_o0);
			_p0_pi0_nc13_o2 = float2(_p0_pi0_nc12_o2, _p0_pi0_nc8_o2);
			_p0_pi0_nc14_o4 = tex2D(_Day, _p0_pi0_nc13_o2).rgb;
			_p0_pi0_nc14_o5 = tex2D(_Day, _p0_pi0_nc13_o2).a;
			_p0_pi0_nc14_o6 = UnpackNormal(tex2D(_Day, _p0_pi0_nc13_o2));
			_p0_pi0_nc15_o3 = tex2D(_Night, _p0_pi0_nc13_o2);
			_p0_pi0_nc15_o4 = tex2D(_Night, _p0_pi0_nc13_o2).rgb;
			_p0_pi0_nc15_o5 = tex2D(_Night, _p0_pi0_nc13_o2).a;
			_p0_pi0_nc15_o6 = UnpackNormal(tex2D(_Night, _p0_pi0_nc13_o2));
			_p0_pi0_nc58_o0 = _SinTime.x;
			_p0_pi0_nc39_o1 = saturate(_p0_pi0_nc58_o0);
			_p0_pi0_nc16_o3 = lerp(_p0_pi0_nc14_o4, _p0_pi0_nc15_o4, _p0_pi0_nc39_o1);
			_p0_pi0_nc14_o3 = tex2D(_Day, _p0_pi0_nc13_o2);
			_p0_pi0_nc67_o1 = normalize(_p0_pi0_nc16_o3).x;
			_p0_pi0_nc71_o0 = _EmissionPower;
			_p0_pi0_nc70_o2 = _p0_pi0_nc15_o4 * _p0_pi0_nc71_o0;
			_p0_pi0_nc72_o0 = _SmoothnessPower;
			_p0_pi0_nc73_o2 = (_p0_pi0_nc72_o0 * _p0_pi0_nc67_o1);
			_p0_pi0_nc75_o1 = normalize(_p0_pi0_nc16_o3).x;
			_p0_pi0_nc76_o1 = normalize(_p0_pi0_nc14_o4).x;
			_p0_pi0_nc74_o4 = (_p0_pi0_nc76_o1) < (_p0_pi0_nc75_o1) ? (_p0_pi0_nc14_o4) : (_p0_pi0_nc16_o3);
			o.Albedo = _p0_pi0_nc74_o4;
			o.Smoothness = _p0_pi0_nc73_o2;
			o.Occlusion = _p0_pi0_nc67_o1;
			o.Emission = _p0_pi0_nc70_o2;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
