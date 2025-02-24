import { describe, it, beforeEach, expect } from "vitest"

describe("Reality Consistency Check Contract", () => {
  let mockStorage: Map<string, any>
  let nextGlitchId: number
  
  beforeEach(() => {
    mockStorage = new Map()
    nextGlitchId = 0
  })
  
  const mockContractCall = (method: string, args: any[]) => {
    switch (method) {
      case "report-glitch":
        const [description, severity] = args
        nextGlitchId++
        mockStorage.set(`glitch-${nextGlitchId}`, {
          description,
          severity,
          status: "reported",
        })
        return { success: true, value: nextGlitchId }
      
      case "update-glitch-status":
        const [glitchId, newStatus] = args
        const glitch = mockStorage.get(`glitch-${glitchId}`)
        if (!glitch) return { success: false, error: 404 }
        glitch.status = newStatus
        return { success: true }
      
      case "get-glitch":
        return { success: true, value: mockStorage.get(`glitch-${args[0]}`) }
      
      default:
        return { success: false, error: "Unknown method" }
    }
  }
  
  it("should report a glitch", () => {
    const result = mockContractCall("report-glitch", ["Reality flicker observed", 8])
    expect(result.success).toBe(true)
    expect(result.value).toBe(1)
  })
  
  it("should update glitch status", () => {
    mockContractCall("report-glitch", ["Reality flicker observed", 8])
    const result = mockContractCall("update-glitch-status", [1, "investigated"])
    expect(result.success).toBe(true)
  })
  
  it("should get glitch information", () => {
    mockContractCall("report-glitch", ["Reality flicker observed", 8])
    const result = mockContractCall("get-glitch", [1])
    expect(result.success).toBe(true)
    expect(result.value).toEqual({
      description: "Reality flicker observed",
      severity: 8,
      status: "reported",
    })
  })
})

