using timeprop
import timeprop: perform_timeprop
using Test

@testset "timeprop.jl" begin
    # 等速度運動のテスト
    @testset "Uniform motion" begin
        # 加速度が0の等速度運動
        F(x, t) = 0.0
        tmax = 1.0
        x0 = 0.0
        a0 = 1.0  # 初期速度
        h = 1e-3   # 時間ステップ

        x_final, a_final = perform_timeprop(F, tmax, x0, a0, h)
        
        # 理論値: x = x0 + v0*t
        expected_x = x0 + a0 * tmax
        expected_a = a0  # 速度は変化しない

        @test isapprox(x_final, expected_x, rtol=1e-10)
        @test isapprox(a_final, expected_a, rtol=1e-10)
    end

    # 等加速度運動のテスト
    @testset "Uniform acceleration motion" begin
        # 加速度が一定の等加速度運動
        F(x, t) = 1.0  # 一定の加速度
        tmax = 1.0
        x0 = 0.0
        a0 = 0.0  # 初期速度
        h = 1e-4   # 時間ステップ

        x_final, a_final = perform_timeprop(F, tmax, x0, a0, h)
        
        # 理論値: x = x0 + v0*t + (1/2)*a*t^2
        # 理論値: v = v0 + a*t
        expected_x = x0 + a0 * tmax + 0.5 * F(0, 0) * tmax^2
        expected_a = a0 + F(0, 0) * tmax

        @test isapprox(x_final, expected_x, rtol=1e-3)
        @test isapprox(a_final, expected_a, rtol=1e-3)
    end

    # バネの運動のテスト
    @testset "Spring motion" begin
        # バネ定数
        k = 1.0
        # バネの力: F = -kx
        F(x, t) = -k * x
        
        tmax = 2π  # 1周期分
        x0 = 1.0   # 初期位置
        a0 = 0.0   # 初期速度
        h = 1e-4   # 時間ステップ

        x_final, a_final = perform_timeprop(F, tmax, x0, a0, h)
        
        # 理論値: x = x0 * cos(ωt), ここでω = √k
        # 理論値: v = -x0 * ω * sin(ωt)
        ω = √k
        expected_x = x0 * cos(ω * tmax)
        expected_a = -x0 * ω * sin(ω * tmax)

        # バネの運動は数値誤差が蓄積しやすいため、許容誤差を大きくする
        @test isapprox(x_final, expected_x, atol=1e-2)
        @test isapprox(a_final, expected_a, atol=1e-2)
    end
end
