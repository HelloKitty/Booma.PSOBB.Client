Shader "Custom/ForestDoorConsole" 
{
	Properties 
	{		
		_ConsoleBackgroundColor ("Console BackgroundColor", Color) = (1,1,1,1)
		_BackgroundTexture ("Background Albedo (RGB)", 2D) = "white" {}

		_CharacterColor ("Character Color", Color) = (1,1,1,1)
		_CharacterTexture ("Character Albedo (RGB)", 2D) = "white" {}

		_ScrollSpeed ("Scrolling Speed", Float) = 1.0


		_EmissionColor ("Emission Color", Color) = (1,1,1)
		_EmissionLM ("Emission (Lightmapper)", Float) = 0
		[Toggle] _DynamicEmissionLM ("Dynamic Emission (Lightmapper)", Int) = 0

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		//textures
		sampler2D _BackgroundTexture;
		sampler2D _CharacterTexture;

		struct Input 
		{
			float2 uv_CharacterTexture;
			float2 uv_BackgroundTexture;
		};

		half _Glossiness;
		half _Metallic;
	
		//colors	
		fixed4 _ConsoleBackgroundColor;
		fixed4 _CharacterColor;
		fixed3 _EmissionColor;

		half _ScrollSpeed;
		half _EmissionLM;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			//background console texture
			fixed4 consoleSampledColor = tex2D(_BackgroundTexture, IN.uv_BackgroundTexture) * _ConsoleBackgroundColor;

			//character map texture
			//uses smooth time to scroll texture
			float2 timeBasedOffset = float2(0, _Time.x * _ScrollSpeed);
			fixed4 characterSampledColor = tex2D(_CharacterTexture, IN.uv_CharacterTexture + timeBasedOffset) * _CharacterColor;

			//selects texture by alpha in the character map
			o.Albedo = lerp(consoleSampledColor, characterSampledColor, characterSampledColor.a).rgb;

			//Do the same with emission
			o.Emission = lerp(0, _EmissionColor * _EmissionLM, characterSampledColor.a);

			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
		}
		ENDCG
	} 
	FallBack "Diffuse"

}
