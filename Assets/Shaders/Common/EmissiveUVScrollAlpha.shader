Shader "Custom/EmissiveUVScrollAlpha" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}

		_ScrollSpeed ("Scrolling Speed", Vector) = (1,1,1,1)

		_EmissionTex ("Emission Map", 2D) = "white" {}
		_EmissionColor ("Emission Color", Color) = (1,1,1)
		_EmissionLM ("Emission (Lightmapper)", Float) = 0
		[Toggle] _DynamicEmissionLM ("Dynamic Emission (Lightmapper)", Int) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _EmissionTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _EmissionColor;
		half _EmissionLM;
		fixed4 _Color;

		float2 _ScrollSpeed;

		void surf (Input IN, inout SurfaceOutputStandard o) 
		{
			// Albedo comes from a texture tinted by color
			float2 uv = IN.uv_MainTex + float2(_Time.x * _ScrollSpeed.x, _Time.y * _ScrollSpeed.y);

			fixed4 c = tex2D (_MainTex, uv) * _Color;
			o.Albedo = c.rgb;

			o.Emission = (tex2D(_EmissionTex, uv) * _EmissionColor).rgb * _EmissionLM;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
