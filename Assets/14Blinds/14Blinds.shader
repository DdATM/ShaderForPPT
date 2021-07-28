Shader "PPT/14百叶窗"
{
   Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _SecondTex ("SecondTex", 2D) = "white" {}
        _Ratio("Ratio",Range(0,1))=0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #define PI 3.1415926
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;              
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SecondTex;
            float4 _SecondTex_ST;
            float _Ratio;


            float2 transform(float2 texCoord, float theta, float2 axisPos, float2 gridNum,float zOffset)
            {
                float2 res = texCoord - axisPos;
                float axisZ = 1.0/ gridNum.x *sqrt(3.0)/6.0; // 旋转轴的z坐标
                float thetaLocal = -theta;
                res = res / (1.0 + zOffset);
                res = res / (1.0 +  axisZ);
                // 执行旋转和投影（投影本质上是剪切）
                res.x = res.x / cos(thetaLocal) - axisZ * sin(thetaLocal);
                res.y = res.y * (1.0 + res.x *  sin(thetaLocal) - axisZ * cos(thetaLocal));
                res.x = res.x * (1.0 + res.x *  sin(thetaLocal) - axisZ * cos(thetaLocal));
                // 从 (0,0) 移动到 axisPos
                res = res + axisPos;
                // 对超出棋盘格范围的坐标进行处理，设置为 -0.001 和 1.001 在 GL_CLAMP_TO_BORDER 模式下取背景色
                float halfGridWidth = 0.5 / gridNum.x;
                float halfGridHeight = 0.5 / gridNum.y;
                if (res.x < axisPos.x - halfGridWidth)        res.x = -0.001;
                if (res.x > axisPos.x + halfGridWidth)        res.x = 1.001;
                if (res.y < axisPos.y - halfGridHeight)        res.y = -0.001;
                if (res.y > axisPos.y + halfGridHeight)        res.y = 1.001;
                return res;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);              
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {             
                float4 resColor ;// 初始化 resColor
                // 设置翻转栅格数量，横向18，纵向1
                float2 gridNum = float2(18.0, 1.0);
                // 获得每个栅格的位置
                float2 axisPos = floor(i.uv * gridNum) * (1.0 / gridNum) + 0.5 / gridNum;
                // 设置每个栅格的旋转角度，与 横向坐标、外界输入ratio 有关
                float rotateTheta = clamp(_Ratio * (1.0 + gridNum.x * 4.0 * pow((0.5 - abs(axisPos.x - 0.5)), 5.0)), 0.0, 1.0) * PI * 2.0 / 3.0;
                // 设置栅格旋转时，向后偏移的量，与 外界输入ratio 有关
                float zOffset = -clamp(0.05 - abs(0.1 * rotateTheta/(PI * 2.0 / 3.0) - 0.05),0.0,0.05);
           
                // 对纹理坐标进行变换，以及纹理采样
                float2 texCoordAfterTransform = transform(i.uv, rotateTheta, axisPos, gridNum,zOffset);
                float4 texColor1 = tex2D(_MainTex, texCoordAfterTransform);
            
                float2 texCoordAfterTransform2 = transform(i.uv, rotateTheta + PI / 3.0, axisPos, gridNum, zOffset);
                texCoordAfterTransform2.x = floor(texCoordAfterTransform2.x * gridNum.x + 1.0) / gridNum.x - texCoordAfterTransform2.x + floor(texCoordAfterTransform2.x * gridNum.x) / gridNum.x;
                float4 texColor2 = tex2D(_SecondTex, texCoordAfterTransform2);
            
                // 根据旋转角度，给每个栅格设置遮罩，左边为第一张图，右边为第二张图
                if (frac(i.uv.x* gridNum.x) <= (0.5+sqrt(3)/3.0*tan(PI/3.0- rotateTheta)))
                    resColor = texColor1 * (1.0 - rotateTheta/(PI * 2.0 / 3.0));
                else
                    resColor = texColor2 * (rotateTheta / (PI * 2.0 / 3.0));
                return resColor;
            }
            ENDCG
        }
    }    
}