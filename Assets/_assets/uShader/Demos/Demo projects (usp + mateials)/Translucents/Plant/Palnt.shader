// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "uSE/Plant" { 
	Properties { 
		_Cutoff_ ("Cutoff", Range(0,1)) = 0.223
		[Header (Textures and Bumpmaps)]_Main("Main", 2D) = "white" {}
		_Trans("Trans", 2D) = "white" {}
		[Header (Colors)]_Diffuse("Diffuse", Color) = (0.6911765,0.6911765,0.6911765,1)
		_Forward("Forward", Color) = (0.6323529,0.6323529,0.6323529,1)
		_Maintint("Main tint", Color) = (0.4896553,1,0,1)
		[Header (Variables)]_Power("Power", float) = 1.2
		_Sourcebrightnes("Source brightnes", float) = 2
		_Ambient("Ambient", float) = 0.74
		_Reflection("Reflection", float) = 0.89
		_Shading("Shading", float) = 0.506
		_Area("Area", float) = 60
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
		#pragma target 4.0
		#include "UnityCG.cginc"

		float _Cutoff_;
		sampler2D _Main;
		sampler2D _Trans;
		float4 _Diffuse;
		float4 _Forward;
		float4 _Maintint;
		float _Power;
		float _Sourcebrightnes;
		float _Ambient;
		float _Reflection;
		float _Shading;
		float _Area;
		float4 _p0_pi0_nc2_o3;
		float3 _p0_pi0_nc2_o4;
		float _p0_pi0_nc2_o5;
		float3 _p0_pi0_nc2_o6;
		float _p0_pi0_nc3_o0;
		float _p0_pi0_nc4_o0;
		float _p0_pi0_nc5_o0;
		float _p0_pi0_nc6_o0;
		float _p0_pi0_nc7_o0;
		float _p0_pi0_nc8_o0;
		float4 _p0_pi0_nc10_o0;
		float3 _p0_pi0_nc10_o1;
		float _p0_pi0_nc10_o2;
		float4 _p0_pi0_nc11_o0;
		float3 _p0_pi0_nc11_o1;
		float _p0_pi0_nc11_o2;
		float4 _p0_pi0_nc12_o3;
		float3 _p0_pi0_nc12_o4;
		float _p0_pi0_nc12_o5;
		float3 _p0_pi0_nc12_o6;
		float4 _p0_pi0_nc14_o0;
		float3 _p0_pi0_nc14_o1;
		float _p0_pi0_nc14_o2;
		float3 _p0_pi0_nc17_o2;

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
			float2 uv_Trans;
			float3 viewDir;
			float3 worldPos;
			float3 worldRefl;
			float3 worldNormal;
			float4 screenPos;
			float4 color : COLOR;
			float4 pos : SV_POSITION;
			float4 posWorld : TEXCOORD0;
			float3 normalDir : TEXCOORD1;

			INTERNAL_DATA
		};

		inline half3 Translucency (Input IN) {
			float3 normalDirection = normalize(IN.normalDir);
			float3 viewDirection = normalize(_WorldSpaceCameraPos - IN.posWorld.xyz);
			normalDirection = faceforward(normalDirection, -viewDirection, normalDirection);
			float3 lightDirection;
			float attenuation;
			if (0.0 == _WorldSpaceLightPos0.w) 
			{
				attenuation = 1.0; // no attenuation
				lightDirection = normalize(_WorldSpaceLightPos0.xyz);
			}
			else
			{
				float3 vertexToLightSource = _WorldSpaceLightPos0.xyz - IN.posWorld.xyz;
				float distance = length(vertexToLightSource);
				attenuation = 1.0 / distance;
				lightDirection = normalize(vertexToLightSource);
			}
			float3 diffuseReflection = attenuation * _LightColor0.rgb * max((_p0_pi0_nc7_o0), dot(normalDirection, lightDirection));
			float3 diffuseTranslucency = attenuation * _LightColor0.rgb * (_p0_pi0_nc10_o1) * max((_p0_pi0_nc7_o0), dot(lightDirection, -normalDirection));
			float3 forwardTranslucency;
			if (dot(normalDirection, lightDirection) > 0.0)
				forwardTranslucency = float3(0.0, 0.0, 0.0);
			else
				forwardTranslucency = attenuation * _LightColor0.rgb * (_p0_pi0_nc11_o1) * pow(max(0.0,dot(-lightDirection, viewDirection)), (_p0_pi0_nc8_o0));
			float3 transLight = UNITY_LIGHTMODEL_AMBIENT.rgb + diffuseReflection * (_p0_pi0_nc6_o0) + diffuseTranslucency * (_p0_pi0_nc5_o0) + forwardTranslucency * (_p0_pi0_nc4_o0);
			transLight *= (_p0_pi0_nc12_o4);
			return transLight;
		}

		void vert (inout appdata v, out Input data){
			UNITY_INITIALIZE_OUTPUT(Input,data);
			data.posWorld = mul(unity_ObjectToWorld, v.vertex);
			data.normalDir = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
			data.pos = UnityObjectToClipPos(v.vertex);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_p0_pi0_nc2_o3 = tex2D(_Main, IN.uv_Main);
			_p0_pi0_nc2_o4 = tex2D(_Main, IN.uv_Main).rgb;
			_p0_pi0_nc2_o5 = tex2D(_Main, IN.uv_Main).a;
			_p0_pi0_nc2_o6 = UnpackNormal(tex2D(_Main, IN.uv_Main));
			_p0_pi0_nc3_o0 = _Power;
			_p0_pi0_nc4_o0 = _Sourcebrightnes;
			_p0_pi0_nc5_o0 = _Ambient;
			_p0_pi0_nc6_o0 = _Reflection;
			_p0_pi0_nc7_o0 = _Shading;
			_p0_pi0_nc8_o0 = _Area;
			_p0_pi0_nc10_o0 = _Diffuse;
			_p0_pi0_nc10_o1 = _Diffuse.rgb;
			_p0_pi0_nc10_o2 = _Diffuse.a;
			_p0_pi0_nc11_o0 = _Forward;
			_p0_pi0_nc11_o1 = _Forward.rgb;
			_p0_pi0_nc11_o2 = _Forward.a;
			_p0_pi0_nc12_o3 = tex2D(_Trans, IN.uv_Main);
			_p0_pi0_nc12_o4 = tex2D(_Trans, IN.uv_Main).rgb;
			_p0_pi0_nc12_o5 = tex2D(_Trans, IN.uv_Main).a;
			_p0_pi0_nc12_o6 = UnpackNormal(tex2D(_Trans, IN.uv_Main));
			_p0_pi0_nc14_o0 = _Maintint;
			_p0_pi0_nc14_o1 = _Maintint.rgb;
			_p0_pi0_nc14_o2 = _Maintint.a;
			_p0_pi0_nc17_o2 = (_p0_pi0_nc14_o1 * _p0_pi0_nc2_o4);
			o.Albedo = _p0_pi0_nc17_o2;
			o.Alpha = _p0_pi0_nc2_o5;
			o.Albedo = lerp(o.Albedo, Translucency(IN) * o.Albedo, (_p0_pi0_nc3_o0));
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
