// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "uSE/Simple post effect" { 
	Properties { 
		[Header (Textures and Bumpmaps)]_Mask("Mask", 2D) = "white" {}
		[Header (Colors)]_MainTint("Main Tint", Color) = (1,1,1,1)
		_MaskTune("Mask Tune", Color) = (1,1,1,1)
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Overlay+1000"
			"RenderType" = "Transparent"
			"ForceNoShadowCasting" = "True"
			"IgnoreProjector" = "True"
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
		#pragma surface surf BlinnPhong vertex:vert 
		#pragma target 4.0
		#include "UnityCG.cginc"

		sampler2D _Mask;
		float4 _MainTint;
		float4 _MaskTune;
		sampler2D _GrabTexture : register(s0);
		uniform half4 _GrabTexture_TexelSize;
		float4 _p0_pi0_nc2_o2;
		float3 _p0_pi0_nc2_o3;
		float4 _p0_pi0_nc4_o3;
		float3 _p0_pi0_nc4_o4;
		float _p0_pi0_nc4_o5;
		float3 _p0_pi0_nc4_o6;
		float3 _p0_pi0_nc5_o3;
		float4 _p0_pi0_nc7_o0;
		float3 _p0_pi0_nc7_o1;
		float _p0_pi0_nc7_o2;
		float3 _p0_pi0_nc8_o2;
		float4 _p0_pi0_nc9_o0;
		float3 _p0_pi0_nc9_o1;
		float _p0_pi0_nc9_o2;

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
			float2 uv_Mask;
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

		void surf (Input IN, inout SurfaceOutput o) {
			_p0_pi0_nc2_o2 = tex2Dproj(_GrabTexture, IN.proj1 + abs(0 * float4(1.0f, 1.0f, 1.0f, 1.0f) - float4(1.0f, 1.0f, 1.0f, 1.0f) / 16 ) - 1.0f / 8 + 1.0f / 15);
			_p0_pi0_nc2_o3 = tex2Dproj(_GrabTexture, IN.proj1 + abs(0 * float4(1.0f, 1.0f, 1.0f, 1.0f) - float4(1.0f, 1.0f, 1.0f, 1.0f) / 16 ) - 1.0f / 8 + 1.0f / 15);
			_p0_pi0_nc4_o3 = tex2D(_Mask, IN.uv_Mask);
			_p0_pi0_nc4_o4 = tex2D(_Mask, IN.uv_Mask).rgb;
			_p0_pi0_nc4_o5 = tex2D(_Mask, IN.uv_Mask).a;
			_p0_pi0_nc4_o6 = UnpackNormal(tex2D(_Mask, IN.uv_Mask));
			_p0_pi0_nc7_o1 = _MaskTune.rgb;
			_p0_pi0_nc7_o0 = _MaskTune;
			_p0_pi0_nc8_o2 = (_p0_pi0_nc4_o4 * _p0_pi0_nc7_o1);
			_p0_pi0_nc7_o2 = _MaskTune.a;
			_p0_pi0_nc9_o1 = _MainTint.rgb;
			_p0_pi0_nc9_o0 = _MainTint;
			_p0_pi0_nc5_o3 = lerp(_p0_pi0_nc2_o3, _p0_pi0_nc9_o1, _p0_pi0_nc8_o2);
			_p0_pi0_nc9_o2 = _MainTint.a;
			o.Emission = _p0_pi0_nc5_o3;
		}
		ENDCG

	}
	FallBack "Diffuse"
}
