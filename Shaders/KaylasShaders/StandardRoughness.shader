// Upgrade NOTE: upgraded instancing buffer 'KaylaStandardRoughness' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Kayla/Standard Roughness"
{
	Properties
	{
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_Albedo("Albedo", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Range( 0 , 10)) = 1
		_Metallic("Metallic", 2D) = "white" {}
		_Roughness("Roughness", 2D) = "white" {}
		_RoughnessAmount("Roughness Amount", Range( 0 , 1)) = 1
		_AOMap("AO Map", 2D) = "white" {}
		_Emission("Emission", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float _NormalScale;
		uniform sampler2D _Albedo;
		uniform sampler2D _Emission;
		uniform sampler2D _Metallic;
		uniform sampler2D _Roughness;
		uniform sampler2D _AOMap;

		UNITY_INSTANCING_BUFFER_START(KaylaStandardRoughness)
			UNITY_DEFINE_INSTANCED_PROP(float4, _Normal_ST)
#define _Normal_ST_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_ST)
#define _Albedo_ST_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionColor)
#define _EmissionColor_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _Emission_ST)
#define _Emission_ST_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _Metallic_ST)
#define _Metallic_ST_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _Roughness_ST)
#define _Roughness_ST_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float4, _AOMap_ST)
#define _AOMap_ST_arr KaylaStandardRoughness
			UNITY_DEFINE_INSTANCED_PROP(float, _RoughnessAmount)
#define _RoughnessAmount_arr KaylaStandardRoughness
		UNITY_INSTANCING_BUFFER_END(KaylaStandardRoughness)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Normal_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Normal_ST_arr, _Normal_ST);
			float2 uv_Normal = i.uv_texcoord * _Normal_ST_Instance.xy + _Normal_ST_Instance.zw;
			o.Normal = UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _NormalScale );
			float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
			float4 _Albedo_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_ST_arr, _Albedo_ST);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST_Instance.xy + _Albedo_ST_Instance.zw;
			o.Albedo = ( _BaseColor_Instance * tex2D( _Albedo, uv_Albedo ) ).rgb;
			float4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			float4 _Emission_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Emission_ST_arr, _Emission_ST);
			float2 uv_Emission = i.uv_texcoord * _Emission_ST_Instance.xy + _Emission_ST_Instance.zw;
			o.Emission = ( _EmissionColor_Instance * tex2D( _Emission, uv_Emission ) ).rgb;
			float4 _Metallic_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Metallic_ST_arr, _Metallic_ST);
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST_Instance.xy + _Metallic_ST_Instance.zw;
			o.Metallic = tex2D( _Metallic, uv_Metallic ).r;
			float4 _Roughness_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Roughness_ST_arr, _Roughness_ST);
			float2 uv_Roughness = i.uv_texcoord * _Roughness_ST_Instance.xy + _Roughness_ST_Instance.zw;
			float _RoughnessAmount_Instance = UNITY_ACCESS_INSTANCED_PROP(_RoughnessAmount_arr, _RoughnessAmount);
			o.Smoothness = ( ( 1.0 - tex2D( _Roughness, uv_Roughness ) ) * _RoughnessAmount_Instance ).r;
			float4 _AOMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_AOMap_ST_arr, _AOMap_ST);
			float2 uv_AOMap = i.uv_texcoord * _AOMap_ST_Instance.xy + _AOMap_ST_Instance.zw;
			o.Occlusion = tex2D( _AOMap, uv_AOMap ).r;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
279;108;2234;652;1223.178;-82.58517;1.149192;True;True
Node;AmplifyShaderEditor.SamplerNode;13;-539.8159,778.3179;Inherit;True;Property;_Roughness;Roughness;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-784,-91.5;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;9;-546,377.5;Inherit;True;Property;_Emission;Emission;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;16;-174.6897,438.5515;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2;-627,-287.5;Inherit;False;InstancedProperty;_BaseColor;Base Color;0;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;11;-467,212.5;Inherit;False;InstancedProperty;_EmissionColor;Emission Color;9;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-776.8143,108.9476;Inherit;False;Property;_NormalScale;Normal Scale;3;0;Create;True;0;0;False;0;False;1;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-236.8855,518.8817;Inherit;False;InstancedProperty;_RoughnessAmount;Roughness Amount;6;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-377,-153.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;5;-447,22.5;Inherit;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-180,280.5;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-548.7545,577.2543;Inherit;True;Property;_Metallic;Metallic;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-535.2693,979.926;Inherit;True;Property;_AOMap;AO Map;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;45.75427,464.1443;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;272.8989,291.5108;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Kayla/Standard Roughness;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;13;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;5;5;7;0
WireConnection;8;0;11;0
WireConnection;8;1;9;0
WireConnection;18;0;16;0
WireConnection;18;1;20;0
WireConnection;0;0;1;0
WireConnection;0;1;5;0
WireConnection;0;2;8;0
WireConnection;0;3;12;0
WireConnection;0;4;18;0
WireConnection;0;5;17;0
ASEEND*/
//CHKSM=AC1A9EAE84777CCF4BB89BEEB839D8D9D53E7C1D