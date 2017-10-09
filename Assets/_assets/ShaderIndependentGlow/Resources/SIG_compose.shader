// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/SIG_Compose" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GlowMask ("Glow mask", 2D) = "black" {}
		_BlurMask ("Blurred glow mask", 2D) = "black" {}
	}

 SubShader {
  Pass{
 CGPROGRAM
#include "UnityCG.cginc"
#pragma vertex vert
#pragma fragment frag	

uniform sampler2D _MainTex;
uniform sampler2D _GlowMask;
uniform sampler2D _BlurMask;

half4 _MainTex_TexelSize;

fixed4 _GlobalTint;
fixed _GlowPower;
fixed _BlurPower;

struct v2f {
		float4 pos : POSITION;
		float2 uv : TEXCOORD0;			
		float2 uv1 : TEXCOORD1;						
	};


v2f vert( appdata_img v )
{
	v2f o;
	o.pos = UnityObjectToClipPos (v.vertex);
	o.uv = MultiplyUV( UNITY_MATRIX_TEXTURE0, v.texcoord );	
	
	o.uv1 = o.uv;
	#if defined(UNITY_HALF_TEXEL_OFFSET)		
		o.uv1.y = o.uv.y - _MainTex_TexelSize * 2;
    #else		
	#endif
	
	#if UNITY_UV_STARTS_AT_TOP		
	if (_MainTex_TexelSize.y < 0)
		o.uv1.y = 1-o.uv1.y;		
	#else
	#endif	
	return o;
}
  

//Fragment Shader
 fixed4 frag (v2f i) : COLOR{
	fixed4 mT = tex2D(_MainTex, i.uv);
	fixed4 gM = tex2D(_GlowMask, i.uv1);
	fixed4 bM = tex2D(_BlurMask, i.uv1);	
	
	mT = saturate(mT + gM * _GlobalTint * _GlowPower + bM * _GlobalTint * _BlurPower);
			
	return mT;
}
 ENDCG
}
} 
}