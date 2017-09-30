Shader "Custom/LavaFlow" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DistortMap ("Distortion Map", 2D) = "white" {}
		_DistortMultiplier ("Distortion Multiplier", Float) = 1.0
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0

		_EmissionLM ("Emission (Lightmapper)", Float) = 0
		[Toggle] _DynamicEmissionLM ("Dynamic Emission (Lightmapper)", Int) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _DistortMap;

		struct Input {
			float2 uv_MainTex;
			float2 uv_DistortMap;
		};

		half _Glossiness;
		half _Metallic;
		half _EmissionLM;
		half _DistortMultiplier;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex + UnpackNormal(tex2D(_DistortMap, IN.uv_DistortMap)) * _DistortMultiplier) * _Color;
			o.Albedo = c;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Emission = _EmissionLM * o.Albedo;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
