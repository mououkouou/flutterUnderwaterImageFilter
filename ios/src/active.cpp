#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

void active(char *path,char *returnPath)
{
    //CLAHE 적용
    Mat image = imread(path);
    Mat lab_image;
    cvtColor(image, lab_image, COLOR_BGR2Lab);

    Mat lab_planes[3];
    split(lab_image, lab_planes);

    Ptr<CLAHE> clahe = createCLAHE();

    clahe->setClipLimit(2.0);

    Mat dst;
    clahe->apply(lab_planes[0], dst);

    dst.copyTo(lab_planes[0]);
    merge(lab_planes, 3, lab_image);
    cvtColor(lab_image, image, COLOR_Lab2BGR);

    //histogram equalizer 적용
    Mat simg;
    cvtColor(image, simg, COLOR_BGR2GRAY);

    Mat bgr[3];
    split(image, bgr);

    double filterFactor = 1;
    int s1 = 1;
    int s2 = 0;

    cvtColor(image, simg, COLOR_BGR2GRAY);

    long int N = simg.rows * simg.cols;

    int histo_b[256];
    int histo_g[256];
    int histo_r[256];

    for (int i = 0; i < 256; i++)
    {
        histo_b[i] = 0;
        histo_g[i] = 0;
        histo_r[i] = 0;
    }

    Vec3b intensity;

    for (int i = 0; i < simg.rows; i++)
    {
        for (int j = 0; j < simg.cols; j++)
        {
            intensity = image.at<Vec3b>(i, j);

            histo_b[intensity.val[0]] = histo_b[intensity.val[0]] + 1;
            histo_g[intensity.val[1]] = histo_g[intensity.val[1]] + 1;
            histo_r[intensity.val[2]] = histo_r[intensity.val[2]] + 1;
        }
    }

    for (int i = 1; i < 256; i++)
    {
        histo_b[i] = histo_b[i] + filterFactor * histo_b[i - 1];
        histo_g[i] = histo_g[i] + filterFactor * histo_g[i - 1];
        histo_r[i] = histo_r[i] + filterFactor * histo_r[i - 1];
    }

    int vmin_b = 0;
    int vmin_g = 0;
    int vmin_r = 0;

    while (histo_b[vmin_b + 1] <= N * s1 / 100)
    {
        vmin_b = vmin_b + 1;
    }
    while (histo_g[vmin_g + 1] <= N * s1 / 100)
    {
        vmin_g = vmin_g + 1;
    }
    while (histo_r[vmin_r + 1] <= N * s1 / 100)
    {
        vmin_r = vmin_r + 1;
    }

    int vmax_b = 254;
    int vmax_g = 254;
    int vmax_r = 254;

    while (histo_b[vmax_b - 1] > (N - ((N / 100) * s2)))
    {
        vmax_b = vmax_b - 1;
    }
    if (vmax_b < 254)
    {
        vmax_b = vmax_b + 1;
    }
    while (histo_g[vmax_g - 1] > (N - ((N / 100) * s2)))
    {
        vmax_g = vmax_g - 1;
    }
    if (vmax_g < 254)
    {
        vmax_g = vmax_g + 1;
    }
    while (histo_r[vmax_r - 1] > (N - ((N / 100) * s2)))
    {
        vmax_r = vmax_r - 1;
    }
    if (vmax_r < 254)
    {
        vmax_r = vmax_r + 1;
    }

    for (int i = 0; i < simg.rows; i++)
    {
        for (int j = 0; j < simg.cols; j++)
        {
            intensity = image.at<Vec3b>(i, j);

            if (intensity.val[0] < vmin_b)
            {
                intensity.val[0] = vmin_b;
            }
            if (intensity.val[0] > vmax_b)
            {
                intensity.val[0] = vmax_b;
            }

            if (intensity.val[1] < vmin_g)
            {
                intensity.val[1] = vmin_g;
            }
            if (intensity.val[1] > vmax_g)
            {
                intensity.val[1] = vmax_g;
            }

            if (intensity.val[2] < vmin_r)
            {
                intensity.val[2] = vmin_r;
            }
            if (intensity.val[2] > vmax_r)
            {
                intensity.val[2] = vmax_r;
            }

            image.at<Vec3b>(i, j) = intensity;
        }
    }
    bgr[0] = (bgr[0] - vmin_b) * 255 / (vmax_b - vmin_b);
    bgr[1] = (bgr[1] - vmin_g) * 255 / (vmax_g - vmin_g);
    bgr[2] = (bgr[2] - vmin_r) * 255 / (vmax_r - vmin_r);

    merge(bgr, 3, image);

    //그린 채널 -40,
    Mat BGRchannels[3];
    split(image, BGRchannels);
    BGRchannels[1] = BGRchannels[1] - 40;
    //channels(bgr)를 image에 담는다
    merge(BGRchannels, 3, image);

    //밝기 추가
    add(image, 20, image);

    imwrite(returnPath, image);
}
