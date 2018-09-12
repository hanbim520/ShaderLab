Shader "CookbookShaders/Chapter02/AnimatedSprite" 
{
	Properties 
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		
		//Create the properties below
		_TexWidth ("Sheet Width", float) = 0.0
		_CellAmount ("Cell Amount", float) = 0.0
		_Speed ("Speed", Range(0.01, 32)) = 12
	}
	
	SubShader 
	{ 
			ZWrite Off
			Blend SrcAlpha One
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		
		//Create the connection to the properties inside of the 
		//CG program
		float _TexWidth;
		float _CellAmount;
		float _Speed;

		struct Input 
		{
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			float2 spriteUV = IN.uv_MainTex;
			float cellWidth = _TexWidth / _CellAmount;

			float2 distance = floor(_Time.y * _Speed); //求得距离
			float row = floor(distance / _CellAmount);//距离求得行号（）
			float col = (distance - row * _CellAmount) ;

			float2 uv = spriteUV + half2(col,-row);
			uv.x /= _CellAmount;
			uv.y /= _CellAmount;

			fixed4 c = tex2D(_MainTex, uv);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
