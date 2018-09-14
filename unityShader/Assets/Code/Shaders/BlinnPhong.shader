Shader "CookbookShaders/Chapter02/BlinnPhong" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("Diffuse Tint",Color)=(1,1,1,1)
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_SpecularMask("Specular Texture",2D) = "White"{}
		_SpecPower("Specular Power",Range(0.1,120)) = 3
	}
	
	SubShader 
	{ 
			ZWrite Off
			Blend SrcAlpha One
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomBlinnPhong

		sampler2D _MainTex;
		sampler2D _SpecularMask;
		float4	_MainTint;
		float4 _SpecularColor;
		float _SpecPower;
		 
		struct SurfaceCustomOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
			fixed Alpha;

		};
		inline fixed4 LightingCustomBlinnPhong(SurfaceCustomOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diff = max(0, dot(s.Normal, lightDir));
			float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
			float spec = pow(max(0.0f, dot(reflectionVector, viewDir)), _SpecPower) * s.Specular;
			float3 finalSpec = s.Specular * spec * _SpecularColor.rgb;

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb *finalSpec);
			c.a = s.Alpha;
			return c;

		}

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_MaskTex;
		};

		void surf(Input IN, inout SurfaceCustomOutput o)
		{
			float4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
			float4 specMask = tex2D(_SpecularMask, IN.uv_MaskTex) * _SpecularColor;

			o.Albedo = c.rgb;
			o.Specular = specMask.r;
			o.SpecularColor = specMask.rgb;
			o.Alpha = c.a;

		}
			/*
		inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float3 halfVector = normalize(lightDir+viewDir);
			float diff = max(0, dot(s.Normal, lightDir));
			float nh = max(0, dot(s.Normal, halfVector));
			float spec = pow(nh, _SpecPower) * _SpecularColor;

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb *_SpecularColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha;
			return c;

		}
		*/

		ENDCG
	} 
	FallBack "Diffuse"
}
