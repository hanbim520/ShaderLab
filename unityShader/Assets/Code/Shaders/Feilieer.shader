Shader "CookbookShaders/Chapter02/FeiLieEr" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_MainTint("Diffuse Tint",Color)=(1,1,1,1)
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_Specular("Specular Amount",Range(0,1) = 0.5
		_SpecPower("Specular Power",Range(0,1)) = 0.5
		_AnisoDir("Anisotropic Direction",2D) = ""{}
		_AnisoOffset("Anisotropic Offset",Range(-1,1))=-0.2
	}
	
	SubShader 
	{ 
			ZWrite Off
			Blend SrcAlpha One
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Anisotropic
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _Specular;
		sampler2D _AnisoDir;
		float4	_MainTint;
		float4 _SpecularColor;
		float _SpecPower;
		float _Specular;
		float _AnisoOffset;
		 
		struct SurfaceAnisoOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 AnisoDir;
			half Specular;
			fixed Gloss;
			fixed Alpha;

		};
		inline fixed4 LightingAnisotropic(SurfaceAnisoOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			fixed3 halfVector = normalize(normalize(lightDir) + normalize(viewDir));
			float NdotL = saturate(dot(s.Normal, lightDir));
			fixed HdotA = dot(normalize(s.Normal+s.AnisoDir))

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
			float2 uv_AnisoDir;
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
