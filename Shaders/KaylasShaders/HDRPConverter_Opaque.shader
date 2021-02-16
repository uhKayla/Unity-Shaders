// Upgrade NOTE: upgraded instancing buffer 'KaylaHDRPConverterOpaque' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Kayla/HDRP Converter/Opaque"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "white" {}
		_BaseColor("Base Color", Color) = (1,1,1,1)
		_NormalMap("Normal Map", 2D) = "bump" {}
		_NormalStrength("Normal Strength", Range( 0 , 100)) = 1
		_MaskMap("Mask Map", 2D) = "white" {}
		_AO("AO", Range( 0 , 1)) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 1
		_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_EmissionMap("Emission Map", 2D) = "white" {}
		[HDR]_EmissionColor("Emission Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform sampler2D _Albedo;
		uniform sampler2D _EmissionMap;
		uniform sampler2D _MaskMap;

		UNITY_INSTANCING_BUFFER_START(KaylaHDRPConverterOpaque)
			UNITY_DEFINE_INSTANCED_PROP(float4, _NormalMap_ST)
#define _NormalMap_ST_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float4, _Albedo_ST)
#define _Albedo_ST_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float4, _BaseColor)
#define _BaseColor_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionMap_ST)
#define _EmissionMap_ST_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float4, _EmissionColor)
#define _EmissionColor_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float4, _MaskMap_ST)
#define _MaskMap_ST_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float, _NormalStrength)
#define _NormalStrength_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float, _Metallic)
#define _Metallic_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float, _Smoothness)
#define _Smoothness_arr KaylaHDRPConverterOpaque
			UNITY_DEFINE_INSTANCED_PROP(float, _AO)
#define _AO_arr KaylaHDRPConverterOpaque
		UNITY_INSTANCING_BUFFER_END(KaylaHDRPConverterOpaque)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _NormalMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalMap_ST_arr, _NormalMap_ST);
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST_Instance.xy + _NormalMap_ST_Instance.zw;
			float _NormalStrength_Instance = UNITY_ACCESS_INSTANCED_PROP(_NormalStrength_arr, _NormalStrength);
			o.Normal = ( UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) ) * _NormalStrength_Instance );
			float4 _Albedo_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Albedo_ST_arr, _Albedo_ST);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST_Instance.xy + _Albedo_ST_Instance.zw;
			float4 _BaseColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_BaseColor_arr, _BaseColor);
			o.Albedo = ( tex2D( _Albedo, uv_Albedo ) * _BaseColor_Instance ).rgb;
			float4 _EmissionMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionMap_ST_arr, _EmissionMap_ST);
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST_Instance.xy + _EmissionMap_ST_Instance.zw;
			float4 _EmissionColor_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionColor_arr, _EmissionColor);
			o.Emission = ( tex2D( _EmissionMap, uv_EmissionMap ) * _EmissionColor_Instance ).rgb;
			float4 _MaskMap_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MaskMap_ST_arr, _MaskMap_ST);
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST_Instance.xy + _MaskMap_ST_Instance.zw;
			float4 tex2DNode8 = tex2D( _MaskMap, uv_MaskMap );
			float _Metallic_Instance = UNITY_ACCESS_INSTANCED_PROP(_Metallic_arr, _Metallic);
			o.Metallic = ( tex2DNode8.r * _Metallic_Instance );
			float _Smoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Smoothness_arr, _Smoothness);
			o.Smoothness = ( tex2DNode8.a * _Smoothness_Instance );
			float _AO_Instance = UNITY_ACCESS_INSTANCED_PROP(_AO_arr, _AO);
			o.Occlusion = ( tex2DNode8.g * _AO_Instance );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;2560;1028;1914.875;203.0795;1;True;True
Node;AmplifyShaderEditor.SamplerNode;2;-1238.204,-297.1288;Inherit;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;8;-1242.453,250.691;Inherit;True;Property;_MaskMap;Mask Map;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;15;-1241.875,452.9205;Inherit;True;Property;_EmissionMap;Emission Map;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-1245.283,65.25323;Inherit;True;Property;_NormalMap;Normal Map;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1246.698,-111.691;Inherit;False;InstancedProperty;_BaseColor;Base Color;1;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-1153.875,639.9205;Inherit;False;InstancedProperty;_EmissionColor;Emission Color;9;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-953.6796,225.211;Inherit;False;InstancedProperty;_Metallic;Metallic;6;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-953.6797,295.9888;Inherit;False;InstancedProperty;_AO;AO;5;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-959.3419,148.771;Inherit;False;InstancedProperty;_NormalStrength;Normal Strength;3;0;Create;True;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-950.6017,369.5977;Inherit;False;InstancedProperty;_Smoothness;Smoothness;7;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1;-638.0091,-108.8599;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-647.9199,182.7444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-647.9199,277.5865;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-646.5042,372.4288;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-646.875,465.9205;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-646.5041,87.90215;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2,-3.415556;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Kayla/HDRP Converter/Opaque;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;1;0;2;0
WireConnection;1;1;3;0
WireConnection;9;0;8;1
WireConnection;9;1;12;0
WireConnection;10;0;8;2
WireConnection;10;1;13;0
WireConnection;11;0;8;4
WireConnection;11;1;14;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;0;0;1;0
WireConnection;0;1;6;0
WireConnection;0;2;16;0
WireConnection;0;3;9;0
WireConnection;0;4;11;0
WireConnection;0;5;10;0
ASEEND*/
//CHKSM=12FD36FC0E4B5B8CD8714C67C47A212BA9FE1754