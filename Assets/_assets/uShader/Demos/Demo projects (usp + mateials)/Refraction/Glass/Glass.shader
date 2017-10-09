// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "uSE/Glass" { 
	Properties { 
		[Header (Textures and Bumpmaps)]_Refractionmap("Refraction map", 2D) = "white" {}
		_Specular("Specular", 2D) = "white" {}
		[Header (Variables)]_RefractionPower("RefractionPower", float) = 0.28
		_Brightness("Brightness", float) = 0.15
		_NormalMaping("NormalMaping", float) = -0.3
		_Occlusion("Occlusion", float) = 1
		_Smoothness("Smoothness", float) = 1
		_SpecularPower("SpecularPower", float) = -0.6
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Opaque"
		}

		Fog {
			Mode Global
			Density 0
			Color (1, 1, 1, 1) 
			Range 0, 300
		}

		GrabPass {
			Name "BASE"
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
		#pragma target 4.0
		#include "UnityCG.cginc"

		sampler2D _Refractionmap;
		sampler2D _Specular;
		float _RefractionPower;
		float _Brightness;
		float _NormalMaping;
		float _Occlusion;
		float _Smoothness;
		float _SpecularPower;
		sampler2D _GrabTexture : register(s0);
		uniform half4 _GrabTexture_TexelSize;
		float _p0_pi0_nc22_o0;
		float4 _p0_pi0_nc26_o3;
		float3 _p0_pi0_nc26_o4;
		float _p0_pi0_nc26_o5;
		float3 _p0_pi0_nc26_o6;
		float _p0_pi0_nc27_o1;
		float4 _p0_pi0_nc29_o2;
		float3 _p0_pi0_nc29_o3;
		float4 _p0_pi0_nc35_o3;
		float3 _p0_pi0_nc35_o4;
		float _p0_pi0_nc35_o5;
		float3 _p0_pi0_nc35_o6;
		float3 _p0_pi0_nc36_o2;
		float _p0_pi0_nc38_o0;
		float _p0_pi0_nc39_o0;
		float3 _p0_pi0_nc40_o2;
		float _p0_pi0_nc41_o0;
		float _p0_pi0_nc43_o2;
		float _p0_pi0_nc44_o0;
		float _p0_pi0_nc45_o2;
		float _p0_pi0_nc46_o0;
		float3 _p0_pi0_nc47_o2;

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
			float2 uv_Refractionmap;
			float2 uv_Specular;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;
			float4 proj1;
			float4 position : POSITION;

			INTERNAL_DATA
		};

		void vert (inout appdata v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
			data.position = UnityObjectToClipPos(v.vertex);
			data.proj1 = ComputeScreenPos(data.position);
			COMPUTE_EYEDEPTH(data.proj1.z);
			#if UNITY_UV_STARTS_AT_TOP
				data.proj1.y = (data.position.w - data.position.y) * 0.5;
			#endif
		}

		void surf (Input IN, inout SurfaceOutputStandardSpecular o) {
			_p0_pi0_nc22_o0 = _RefractionPower;
			_p0_pi0_nc26_o3 = tex2D(_Specular, IN.uv_Refractionmap);
			_p0_pi0_nc26_o4 = tex2D(_Specular, IN.uv_Refractionmap).rgb;
			_p0_pi0_nc26_o5 = tex2D(_Specular, IN.uv_Refractionmap).a;
			_p0_pi0_nc26_o6 = UnpackNormal(tex2D(_Specular, IN.uv_Refractionmap));
			_p0_pi0_nc35_o4 = tex2D(_Refractionmap, IN.uv_Refractionmap).rgb;
			_p0_pi0_nc35_o6 = UnpackNormal(tex2D(_Refractionmap, IN.uv_Refractionmap));
			_p0_pi0_nc29_o3 = tex2Dproj(_GrabTexture, IN.proj1 + abs(_p0_pi0_nc35_o6.r * _p0_pi0_nc35_o6.g * _p0_pi0_nc35_o6.b * _p0_pi0_nc22_o0 - _p0_pi0_nc22_o0 / 16 ) - _p0_pi0_nc22_o0 / 8 + _p0_pi0_nc22_o0 / 15);
			_p0_pi0_nc35_o3 = tex2D(_Refractionmap, IN.uv_Refractionmap);
			_p0_pi0_nc27_o1 = normalize(_p0_pi0_nc35_o4).x;
			_p0_pi0_nc35_o5 = tex2D(_Refractionmap, IN.uv_Refractionmap).a;
			_p0_pi0_nc29_o2 = tex2Dproj(_GrabTexture, IN.proj1 + abs(_p0_pi0_nc35_o6.r * _p0_pi0_nc35_o6.g * _p0_pi0_nc35_o6.b * _p0_pi0_nc22_o0 - _p0_pi0_nc22_o0 / 16 ) - _p0_pi0_nc22_o0 / 8 + _p0_pi0_nc22_o0 / 15);
			_p0_pi0_nc38_o0 = _Brightness;
			_p0_pi0_nc36_o2 = (_p0_pi0_nc29_o3 + _p0_pi0_nc38_o0);
			_p0_pi0_nc39_o0 = _NormalMaping;
			_p0_pi0_nc40_o2 = _p0_pi0_nc26_o6 * _p0_pi0_nc39_o0;
			_p0_pi0_nc41_o0 = _Occlusion;
			_p0_pi0_nc43_o2 = (_p0_pi0_nc41_o0 * _p0_pi0_nc27_o1);
			_p0_pi0_nc44_o0 = _Smoothness;
			_p0_pi0_nc45_o2 = (_p0_pi0_nc27_o1 * _p0_pi0_nc44_o0);
			_p0_pi0_nc46_o0 = _SpecularPower;
			_p0_pi0_nc47_o2 = _p0_pi0_nc26_o4 * _p0_pi0_nc46_o0;
			o.Smoothness = _p0_pi0_nc45_o2;
			o.Specular = _p0_pi0_nc47_o2;
			o.Occlusion = _p0_pi0_nc43_o2;
			o.Albedo = _p0_pi0_nc36_o2;
			o.Normal = _p0_pi0_nc40_o2;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
