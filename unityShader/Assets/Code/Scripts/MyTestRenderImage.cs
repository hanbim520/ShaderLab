using UnityEngine;
[ExecuteInEditMode]
public class MyTestRenderImage : MonoBehaviour
{
    public Shader curShader = null;

    [Range(0f, 1f)]//添加此特性后可在Inspector面板中使用滑动条控制grayScaleAmount
    //控制灰度值
    public float grayScaleAmount = 1.0f;

    private Material curMaterial = null;
    private Material CurMaterial
    {
        get
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(curShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            return curMaterial;
        }
    }

    private void Start()
    {
        if (!SystemInfo.supportsImageEffects)
        {
            enabled = false;
            return;
        }
        if (!curShader && !curShader.isSupported)
        {
            enabled = false;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (curShader)
        {
            //使用grayScaleAmount控制着色器中对应的属性数值
            CurMaterial.SetFloat("_LuminosityAmount", grayScaleAmount);
            Graphics.Blit(source, destination, CurMaterial);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void Update()
    {
        //检查并将grayScaleAmount的值限定在0到1之间
        grayScaleAmount = Mathf.Clamp01(grayScaleAmount);
    }

    private void OnDisable()
    {
        if (curMaterial)
        {
            DestroyImmediate(curMaterial);
        }
    }
}