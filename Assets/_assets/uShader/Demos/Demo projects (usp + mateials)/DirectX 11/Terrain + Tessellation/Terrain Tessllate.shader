Shader "uSE/Terrain Tessllate" { 
	Properties { 
		_Cutoff_ ("Cutoff", Range(0,1)) = 0
		[HideInInspector] _Control ("Control (RGBA)", 2D) = "red" {}
		[HideInInspector] _Splat3 ("Layer 3 (A)", 2D) = "white" {}
		[HideInInspector] _Splat2 ("Layer 2 (B)", 2D) = "white" {}
		[HideInInspector] _Splat1 ("Layer 1 (G)", 2D) = "white" {}
		[HideInInspector] _Splat0 ("Layer 0 (R)", 2D) = "white" {}
		[HideInInspector] _Normal3 ("Normal 3 (A)", 2D) = "bump" {}
		[HideInInspector] _Normal2 ("Normal 2 (B)", 2D) = "bump" {}
		[HideInInspector] _Normal1 ("Normal 1 (G)", 2D) = "bump" {}
		[HideInInspector] _Normal0 ("Normal 0 (R)", 2D) = "bump" {}
		[Header (Terrain tesselation)]
		[NoScaleOffset]_DispMap0 ("Displacment map 0 (R)", 2D) = "white" {}
		[NoScaleOffset]_DispMap1 ("Displacment map 1 (G)", 2D) = "white" {}
		[NoScaleOffset]_DispMap2 ("Displacment map 2 (B)", 2D) = "white" {}
		[NoScaleOffset]_DispMap3 ("Displacment map 3 (A)", 2D) = "white" {}
		[Header (Tessellation config)]_TessMultiplier_("Polygons multiplier", float) = 60
		_Displacement_("Displacement", float) = 0.07
		[Header (Textures and Bumpmaps)]_BRDF("BRDF", 2D) = "white" {}
		_Occlusion("Occlusion", 2D) = "white" {}
		[Header (Colors)]_MainTint("MainTint", Color) = (1,1,1,1)
		[Header (Variables)]_OcclusionPower("OcclusionPower", float) = 0.4
		_NormalMapping("NormalMapping", float) = 1
		_Brightness("Brightness", float) = 1
		_Gamma("Gamma", float) = 0
	}
	SubShader {
		LOD 300
		Tags {
			"Queue" = "Geometry"
			"RenderType" = "Opaque"
			"SplatCount" = "4"
		}

		Cull Off
		ColorMask   RGBA

		CGPROGRAM 
		#pragma surface surf USShader vertex:vert tessellate:tess 
		#pragma target 4.0
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"

		float _Cutoff_;
		uniform sampler2D _Control;
		uniform sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
		uniform sampler2D _Normal0,_Normal1,_Normal2,_Normal3;
		uniform sampler2D _DispMap0, _DispMap1,_DispMap2,_DispMap3;
		sampler2D _BRDF;
		sampler2D _Occlusion;
		float4 _MainTint;
		float _OcclusionPower;
		float _NormalMapping;
		float _Brightness;
		float _Gamma;
		float _TessMultiplier_;
		float _Displacement_;
		uniform float4 _DispMap_ST;

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
			float2 uv_Control;
			float2 uv_Splat0;
			float2 uv_Splat1;
			float2 uv_Splat2;
			float2 uv_Splat3;
			float2 uv_BRDF;
			float2 uv_Occlusion;
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
			outputCol = float4(( o.Albedo * _LightColor0.rgb * tex2D(_BRDF, float2(max( 0.5, dot(o.Normal, lightDir) ), 1 - pow( clamp(1.0 - dot ( normalize( lightDir + viewDir ), normalize(o.Normal) ), 0.0, 1.0), 1.0 )) ).rgb + _LightColor0.rgb * float4(1, 1, 1, 1) .rgb * pow( max( 0, dot(o.Normal, normalize( lightDir + viewDir )) ), o.Specular * 1.0) * o.Gloss ) *  atten * 2, 1) * 1.7;
			return outputCol;
		}

		float4 tess (appdata v0, appdata v1, appdata v2) {
			float minDist = 10.0;
			float maxDist = 25.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _TessMultiplier_);

		}

		inline half4 DiffuseLight (half3 lightDir, half3 normal, half4 color) {
			#ifndef USING_DIRECTIONAL_LIGHT
			lightDir = normalize(lightDir);
			#endif
			half diffuse = dot(normal * 2 -1, lightDir);
			half4 c;
			c.rgb = clamp(0, color.rgb, color.rgb * (diffuse) + color.rgb);
			c.a = 0;
			return c;
		}

		void vert (inout appdata v){
			fixed4 splat_control = tex2Dlod(_Control, float4(v.texcoord.xy, 0, 0));
			float terrainDispMap = splat_control.r * tex2Dlod(_DispMap0, float4(v.texcoord.xy * fixed2(500, 500) / float2(1,1) + float2(0,0), 0, 0)).r;
			terrainDispMap += splat_control.g * tex2Dlod(_DispMap1, float4(v.texcoord.xy * fixed2(500, 500) / float2(1,1) + float2(0,0), 0, 0)).r;
			terrainDispMap += splat_control.b * tex2Dlod(_DispMap2, float4(v.texcoord.xy * fixed2(500, 500) / float2(1,1) + float2(0,0), 0, 0)).r;
			terrainDispMap += splat_control.a * tex2Dlod(_DispMap3, float4(v.texcoord.xy * fixed2(500, 500) / float2(1,1) + float2(0,0), 0, 0)).r;
			float disp = (terrainDispMap).r * _Displacement_;
			v.vertex.xyz += v.normal * disp;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 splat_control = tex2D (_Control, IN.uv_Control);
			fixed3 terrainDataColorMul = splat_control.r * tex2D (_Splat0, IN.uv_Splat0).rgb;
			terrainDataColorMul += splat_control.g * tex2D (_Splat1, IN.uv_Splat1).rgb;
			terrainDataColorMul += splat_control.b * tex2D (_Splat2, IN.uv_Splat2).rgb;
			terrainDataColorMul += splat_control.a * tex2D (_Splat3, IN.uv_Splat3).rgb;
			fixed3 terrainDataNormalMul = splat_control.r * tex2D (_Normal0, IN.uv_Splat0).rgb;
			terrainDataNormalMul += splat_control.g * tex2D (_Normal1, IN.uv_Splat1).rgb;
			terrainDataNormalMul += splat_control.b * tex2D (_Normal2, IN.uv_Splat2).rgb;
			terrainDataNormalMul += splat_control.a * tex2D (_Normal3, IN.uv_Splat3).rgb;
			o.Albedo = _MainTint.rgb * lerp(terrainDataColorMul, terrainDataColorMul * tex2D(_Occlusion, IN.uv_BRDF * 500).rgb, _OcclusionPower) * _Brightness + _Gamma;
			o.Albedo = DiffuseLight( ObjSpaceLightDir(float4(IN.worldPos,0)),terrainDataNormalMul * _NormalMapping, half4(o.Albedo.rgb,0));
			if(o.Alpha < _Cutoff_) discard;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
