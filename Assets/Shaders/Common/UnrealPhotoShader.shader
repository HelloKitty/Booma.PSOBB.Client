Shader "Custom/UnrealPhotoShader" {
	Properties {
		_Brightness ("Brightness", Float) = 1.0
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "bump" {}
		//_RoughnessContrast ("Roughness Contrast", Range(0,1)) = 0.1

		_MinSpec ("Minimum Specular", Float) = 0.0
		_MaxSpec ("Maximum Specular", Float) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf StandardSpecular fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input 
		{
			float2 uv_MainTex;
		};

		half _Metallic;
		half _Brightness;
		half _MinSpec;
		half _MaxSpec;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandardSpecular o)
		{
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

			fixed4 normalTex = tex2D(_NormalMap, IN.uv_MainTex);

			//flip green
			normalTex.g = 1 - normalTex.g;

			//Add normal map
			o.Normal = UnpackNormal(normalTex);

			//UE4 defines it was a lerp. They use contrasting though? Idk if we need to replicate that.
			//red channel actually contrains roughness
			o.Smoothness = 1 - lerp(1, 0.6, c.r);

			// Metallic and smoothness come from slider variables
			fixed spec = lerp(_MaxSpec, _MinSpec, c.r);

			//UE4 comment indicates this removes specularity from the photoscan
			o.Albedo = c.rgb - 0.028 * spec;

			//they reduce brightness by 0.75 for some reason; I think it looks bad, so I'm going to increase brightness
			o.Albedo = c.rgb * _Brightness;

			o.Specular = spec * o.Albedo; //alpha is spec map on (optional on UE4 Photoscan shaders)
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
