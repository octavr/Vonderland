Shader "Metal" { 
	Properties { 
		_Tex0("Main", 2D) = "white" {}
		_Tex1("Normal", 2D) = "white" {}
		_Tex2("Brdf", 2D) = "white" {}
		_Cube0("Sky", CUBE) = "" {}
		_Variable0("FalloffPower", float) = 2.18
		_Variable1("ReflectionPower", float) = 0.88
		_Variable2("ReflectionAmount", float) = 1.9
		_Variable3("EmissionPow", float) = 2
		_Variable4("EmissionAmount", float) = 0.5
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		CGPROGRAM 
		#pragma surface surf USShader vertex:vert 
		#include "UnityCG.cginc"

		sampler2D _Tex0;
		sampler2D _Tex1;
		sampler2D _Tex2;
		samplerCUBE _Cube0;
		float _Variable0;
		float _Variable1;
		float _Variable2;
		float _Variable3;
		float _Variable4;

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
			float2 uv_Tex0;
			float2 uv_Tex1;
			float2 uv_Tex2;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;

			INTERNAL_DATA
		};

		inline float4 LightingUSShader (SurfaceOutput o, fixed3 lightDir, half3 viewDir, fixed atten){
			float4 outputCol;
			outputCol = float4((o.Albedo * _LightColor0.rgb * max (0, dot (o.Normal, lightDir)) + _LightColor0.rgb * pow ( max (0, dot (o.Normal, normalize (lightDir + viewDir))), 48.0)) * (atten *2), 1.0f);
			return outputCol;
		}

		void vert (inout appdata_full v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			float3 var42 = texCUBE(_Cube0, float4(IN.worldNormal, 1.0f)).rgb;
			o.Normal = UnpackNormal(tex2D(_Tex1, IN.uv_Tex0));
			o.Albedo = tex2D(_Tex0, IN.uv_Tex0).rgb * pow(texCUBE(_Cube0, float4(IN.worldNormal, 1.0f)).rgb, _Variable1) * _Variable2;
			o.Gloss = 1;
			o.Alpha = tex2D(_Tex0, IN.uv_Tex0).a;
			o.Emission = pow(texCUBE(_Cube0, float4(IN.viewDir, 1.0f)).rgb * texCUBE(_Cube0, float4(IN.worldRefl, 1.0f)).rgb, _Variable3) * _Variable4;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
