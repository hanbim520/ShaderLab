Shader "CookbookShaders/Chapter02/BlinnPhong" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("Diffuse Tint",Color)=(1,1,1,1)
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_SpecPower("Specular Power",Range(0.1,60)) = 3
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
		float4	_MainTint;
		float4 _SpecularColor;
		float _SpecPower;
		 
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

		ENDCG
	} 
	FallBack "Diffuse"
}
