Shader "RenderImage/MyTestRenderImage"
{
	Properties
	{
		_MainTex("Base Tex", 2D) = "white"{}
		_LuminosityAmount("GrayScale Amount", Range(0.0, 1)) = 1.0
	}

		SubShader
	{
		Tags{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
			"PreviewType" = "Plane"
			"CanUseSpriteAtlas" = "true"
		}
		Cull Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
	
		Pass
	{
		CGPROGRAM

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "UnityUI.cginc"
		bool _UseClipRect;
	bool _UseAlphaClip;
	float4 _ClipRect;
		sampler2D _MainTex;
	fixed _LuminosityAmount;

	struct appdata_t
	{
		float4 vertex :POSITION;
		float4 color  :COLOR;
		float2 texcoord:TEXCOORD0;
	};

	struct v2f
	{
		float4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
		float4 worldPosition:TEXCOORD1;
		fixed4 color : COLOR;
	};

	v2f vert(appdata_t v)
	{
		v2f o;
		o.worldPosition = v.vertex;
		o.pos = UnityObjectToClipPos(o.worldPosition);
		o.uv = v.texcoord;
#ifdef UNITY_HALF_TEXEL_OFFSET
		o.uv.xy += (_ScreenParams.zw - 1.0) * float2(-1, 1);
#endif
		o.color = v.color;
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		fixed4 renderTex = tex2D(_MainTex, i.uv) * i.color;

		float luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g + 0.114 * renderTex.b;
		renderTex = lerp(renderTex, luminosity, _LuminosityAmount);
		renderTex.a = 1;
	//	renderTex.r = renderTex.g = renderTex.b = luminosity;
		if (_UseClipRect)
		{
			renderTex *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
		}
		if (_UseAlphaClip)
		{
			clip(renderTex.a - 0.001);
		}
		return renderTex;
	}

		ENDCG
	}
	}

}   //end shader