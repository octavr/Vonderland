Shader "uSE/Cutom LM (Reflection Probes + Light)" { 
	Properties { 
		_Cutoff_ ("Cutoff", Range(0,1)) = 0
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
		}

		Cull Off
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf USShader vertex:vert 
		#include "UnityCG.cginc"

		float _Cutoff_;

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
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;

			INTERNAL_DATA
		};

		inline float4 LightingUSShader (SurfaceOutput o, fixed3 lightDir, half3 viewDir, fixed atten){
			float4 _RPhdrReflection = 1.0;
			float3 _RPreflectedDir = reflect(-1*viewDir, o.Normal);
			float4 _RPreflection = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, _RPreflectedDir);
			_RPhdrReflection.rgb = DecodeHDR(_RPreflection, unity_SpecCube0_HDR);
			_RPhdrReflection.a = 1.0;
			float4 outputCol;
			outputCol = _RPhdrReflection * _LightColor0;
			return outputCol;
		}

		void vert (inout appdata v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
