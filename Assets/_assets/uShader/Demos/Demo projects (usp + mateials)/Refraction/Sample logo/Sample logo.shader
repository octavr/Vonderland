// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "uSE - Refraction" { 
	Properties { 
		_Texture("Texture", 2D) = "white" {}
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Opaque"
		}

		GrabPass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
		}
		Cull Off
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf Lambert vertex:vert 
		#pragma target 4.0
		#include "UnityCG.cginc"

		sampler2D _Texture;
		sampler2D _GrabTexture : register(s0);
		uniform half4 _GrabTexture_TexelSize;

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

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2Dproj(_GrabTexture, IN.proj1 + tex2D(_Texture, IN.uv_Texture + _Time.x * 0.15).rgb.r * tex2D(_Texture, IN.uv_Texture + _Time.x * 0.15).rgb.g * tex2D(_Texture, IN.uv_Texture + _Time.x * 0.15).rgb.b * 1.0f);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
