Shader "Very simple metalic" { 
	Properties { 
		_Tex0("main", 2D) = "white" {}
		_Tex1("normal", 2D) = "white" {}
		_Tex2("brdf", 2D) = "white" {}
		_Cube0("Cubmap", CUBE) = "" {}
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
			outputCol = float4(( o.Albedo * _LightColor0.rgb * tex2D(_Tex2, float2(max( 0.5, dot(o.Normal, lightDir) ), 1 - pow( clamp(1.0 - dot ( normalize( lightDir + viewDir ), normalize(o.Normal) ), 0.0, 1.0), 0.66 )) ).rgb + _LightColor0.rgb * float4(1, 1, 1, 1) .rgb * pow( max( 0, dot(o.Normal, normalize( lightDir + viewDir )) ), o.Specular * 8.0) * o.Gloss ) *  atten * 2, 1);
			return outputCol;
		}

		void vert (inout appdata_full v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_Tex0, IN.uv_Tex0).rgb * texCUBE(_Cube0, float4(IN.viewDir, 1.0f)).rgb;
			o.Normal = UnpackNormal(tex2D(_Tex1, IN.uv_Tex0));
		}
		ENDCG
	}
	FallBack "Diffuse"
}
