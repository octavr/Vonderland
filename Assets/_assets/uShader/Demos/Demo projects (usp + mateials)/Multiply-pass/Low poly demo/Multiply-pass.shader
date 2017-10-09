// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "uSE/Multiply-pass" { 
	Properties { 
		_Cutoff_ ("Cutoff", Range(0,1)) = 0.636
		[Header (Textures and Bumpmaps)]_Main("Main", 2D) = "white" {}
		_Bump("Bump", 2D) = "white" {}
		[Header (Colors)]_MainTint("MainTint", Color) = (0.06617647,0.06617647,0.06617647,1)
		_Metallic("Metallic", Color) = (0.7132353,0.7132353,0.7132353,0.184)
		_Gridcolor("Grid color", Color) = (0.4482759,1,0,1)
		_Grabpassnormal("Grab pass normal", Color) = (1,1,1,1)
		_Emission("Emission", Color) = (0.09558821,0.09558821,0.09558821,1)
		[Header (Variables)]_NormalPower("NormalPower", float) = 3
		_DX("DX", float) = 0.5
		_Thinkness("Thinkness", float) = 0.1
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

		Cull Back
		ZWrite  On
		ZTest  Less
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf Standard vertex:vert 
		#include "UnityCG.cginc"

		float _Cutoff_;
		sampler2D _Main;
		sampler2D _Bump;
		float4 _MainTint;
		float4 _Metallic;
		float4 _Gridcolor;
		float4 _Grabpassnormal;
		float4 _Emission;
		float _NormalPower;
		float _DX;
		float _Thinkness;
		float3 _p0_pi0_nc0_o4;
		float _p0_pi0_nc0_o5;
		float3 _p0_pi0_nc3_o6;
		float _p0_pi0_nc7_o1;
		float _p0_pi0_nc8_o0;
		float3 _p0_pi0_nc9_o2;
		float3 _p0_pi0_nc12_o1;
		float3 _p0_pi0_nc13_o2;
		float4 _p0_pi0_nc17_o0;
		float _p0_pi0_nc17_o2;

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
			float2 uv_Bump;
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

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_p0_pi0_nc0_o4 = tex2D(_Main, IN.uv_Main).rgb;
			_p0_pi0_nc0_o5 = tex2D(_Main, IN.uv_Main).a;
			_p0_pi0_nc3_o6 = UnpackNormal(tex2D(_Bump, IN.uv_Main));
			_p0_pi0_nc17_o0 = _Metallic;
			_p0_pi0_nc8_o0 = _NormalPower;
			_p0_pi0_nc9_o2 = _p0_pi0_nc3_o6 * _p0_pi0_nc8_o0;
			_p0_pi0_nc12_o1 = _MainTint.rgb;
			_p0_pi0_nc13_o2 = (_p0_pi0_nc0_o4 * float3(1.0f, 1.0f, 1.0f));
			_p0_pi0_nc7_o1 = (_p0_pi0_nc17_o0).x;
			_p0_pi0_nc17_o2 = _Metallic.a;
			o.Albedo = _p0_pi0_nc13_o2;
			o.Normal = _p0_pi0_nc9_o2;
			o.Smoothness = _p0_pi0_nc17_o2;
			o.Emission = _p0_pi0_nc12_o1;
			o.Metallic = _p0_pi0_nc7_o1;
			o.Alpha = _p0_pi0_nc0_o5;
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG

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

		Cull Back
		ZWrite  On
		ZTest  Greater
		Lighting   Off
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf Standard vertex:vert addshadow 
		#pragma target 4.0
		#include "UnityCG.cginc"

		float _Cutoff_;
		sampler2D _Main;
		sampler2D _Bump;
		float4 _MainTint;
		float4 _Metallic;
		float4 _Gridcolor;
		float4 _Grabpassnormal;
		float4 _Emission;
		float _NormalPower;
		float _DX;
		float _Thinkness;
		sampler2D _GrabTexture : register(s0);
		uniform half4 _GrabTexture_TexelSize;
		float _p1_pi0_nc3_o2;
		float4 _p1_pi0_nc4_o0;
		float _p1_pi0_nc5_o1;
		float _p1_pi0_nc6_o0;
		float3 _p1_pi0_nc7_o4;
		float _p1_pi0_nc8_o0;
		float3 _p1_pi0_nc11_o1;
		float _p1_pi0_nc12_o2;
		float3 _p1_pi0_nc13_o4;
		float4 _p1_pi0_nc14_o0;
		float _p1_pi0_nc15_o2;
		float _p1_pi0_nc16_o0;
		float _p1_pi0_nc22_o4;
		float _p1_pi0_nc23_o0;
		float _p1_pi0_nc24_o0;
		float _p1_pi0_nc25_o4;
		float3 _p1_pi0_nc34_o3;
		float3 _p1_pi0_nc35_o2;
		float3 _p1_pi0_nc38_o1;
		float3 _p1_pi0_nc43_o1;

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
			float2 uv_Bump;
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
				data.proj1.y = (data.position.w - data.position.y) * 0.494f;
			#endif
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			_p1_pi0_nc4_o0 = IN.screenPos;
			_p1_pi0_nc5_o1 = (_p1_pi0_nc4_o0).x;
			_p1_pi0_nc6_o0 = _DX;
			_p1_pi0_nc3_o2 = fmod(_p1_pi0_nc5_o1, _p1_pi0_nc6_o0);
			_p1_pi0_nc8_o0 = _Thinkness;
			_p1_pi0_nc11_o1 = _Gridcolor.rgb;
			_p1_pi0_nc38_o1 = _Grabpassnormal.rgb;
			_p1_pi0_nc14_o0 = IN.screenPos;
			_p1_pi0_nc15_o2 = (_p1_pi0_nc14_o0).y;
			_p1_pi0_nc16_o0 = _DX;
			_p1_pi0_nc12_o2 = fmod(_p1_pi0_nc15_o2, _p1_pi0_nc16_o0);
			_p1_pi0_nc34_o3 = tex2Dproj(_GrabTexture, IN.proj1 + abs(_p1_pi0_nc38_o1.r * _p1_pi0_nc38_o1.g * _p1_pi0_nc38_o1.b * 1.0f - 1.0f / 16 ) - 1.0f / 8 + 1.0f / 15);
			_p1_pi0_nc23_o0 = _Thinkness;
			_p1_pi0_nc24_o0 = 0;
			_p1_pi0_nc25_o4 = (_p1_pi0_nc12_o2) <= (_p1_pi0_nc23_o0) ? (_p1_pi0_nc24_o0) : (1.0f);
			_p1_pi0_nc22_o4 = (_p1_pi0_nc3_o2) <= (_p1_pi0_nc23_o0) ? (_p1_pi0_nc24_o0) : (_p1_pi0_nc25_o4);
			_p1_pi0_nc35_o2 = (_p1_pi0_nc11_o1 * _p1_pi0_nc34_o3);
			_p1_pi0_nc13_o4 = (_p1_pi0_nc12_o2) >= (_p1_pi0_nc8_o0) ? (_p1_pi0_nc35_o2) : (float3(1.0f, 1.0f, 1.0f));
			_p1_pi0_nc7_o4 = (_p1_pi0_nc3_o2) >= (_p1_pi0_nc8_o0) ? (_p1_pi0_nc35_o2) : (_p1_pi0_nc13_o4);
			_p1_pi0_nc43_o1 = _Emission.rgb;
			o.Albedo = _p1_pi0_nc7_o4;
			o.Alpha = _p1_pi0_nc22_o4;
			o.Emission = _p1_pi0_nc43_o1;
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
