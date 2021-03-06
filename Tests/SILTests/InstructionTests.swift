// TODO(TF-764): Make sure that libSIL tests run on Linux.
// At the moment, InstructionTests use a macOS-only trick to dynamically generate test cases.
// That not just doesn't work on Linux but also doesn't compile.
#if os(macOS)
import XCTest
@testable import SIL

final class InstructionTests: XCTestCase {
    private static var instructionDefs = [
        "%103 = builtin \"ptrtoint_Word\"(%101 : $Builtin.RawPointer) : $Builtin.Word",
        "%139 = builtin \"smul_with_overflow_Int64\"(%136 : $Builtin.Int64, %137 : $Builtin.Int64, %138 : $Builtin.Int1) : $(Builtin.Int64, Builtin.Int1)",
        "cond_fail %141 : $Builtin.Int1, \"\"",
        "%112 = integer_literal $Builtin.Int32, 1",
        "return %1 : $Int",
        "return %280 : $()",
        "%180 = struct $Bool (%179 : $Builtin.Int1)",
        "%211 = struct $StaticString (%210 : $Builtin.Word, %209 : $Builtin.Word, %168 : $Builtin.Int8)",
        "%21 = struct_extract %20 : $Int, #Int._value",
        "%64 = tuple_extract %63 : $(Builtin.Int64, Builtin.Int1), 0",
        "alloc_stack $Float",
        "alloc_stack $IndexingIterator<Range<Int>>, var, name \"$inputIndex$generator\"",
        "apply %10(%1) : $@convention(method) (@guaranteed Array<Float>) -> Int",
        "apply %17<Self>(%1, %2, %16) : $@convention(witness_method: Comparable) <τ_0_0 where τ_0_0 : Comparable> (@in_guaranteed τ_0_0, @in_guaranteed τ_0_0, @thick τ_0_0.Type) -> Bool",
        "apply %8<Int, Int>(%2, %6) : $@convention(thin) <τ_0_0, τ_0_1 where τ_0_0 : Strideable, τ_0_1 : Strideable> (@in_guaranteed τ_0_0, @in_guaranteed τ_0_1) -> ()",
        "begin_access [modify] [static] %0 : $*Array<Float>",
        "begin_apply %266(%125, %265) : $@yield_once @convention(method) (Int, @inout Array<Float>) -> @yields @inout Float",
        "br bb9",
        "br label (%0 : $A, %1 : $B)",
        "cond_br %11, bb3, bb2",
        "cond_br %12, label (%0 : $A), label (%1 : $B)",
        "copy_addr %1 to [initialization] %33 : $*Self",
        "dealloc_stack %162 : $*IndexingIterator<Range<Int>>",
        "debug_value %1 : $Array<Float>, let, name \"input\", argno 2",
        "debug_value %11 : $Int, let, name \"n\"",
        "debug_value_addr %0 : $*Array<Float>, var, name \"out\", argno 1",
        "end_access %265 : $*Array<Float>",
        "end_access [abort] %42 : $T",
        "end_apply %268",
        "float_literal $Builtin.FPIEEE32, 0x0",
        "float_literal $Builtin.FPIEEE64, 0x3F800000",
        "function_ref @$s4main11threadCountSiyF : $@convention(thin) () -> Int",
        "function_ref @$ss6stride4from2to2bys8StrideToVyxGx_x0E0QztSxRzlF : $@convention(thin) <τ_0_0 where τ_0_0 : Strideable> (@in_guaranteed τ_0_0, @in_guaranteed τ_0_0, @in_guaranteed τ_0_0.Stride) -> @out StrideTo<τ_0_0>",
        "function_ref @$s4main1CV3fooyyqd___qd_0_tSayqd__GRszSxRd_0_r0_lF : $@convention(method) <τ_0_0><τ_1_0, τ_1_1 where τ_0_0 == Array<τ_1_0>, τ_1_1 : Strideable> (@in_guaranteed τ_1_0, @in_guaranteed τ_1_1, C<Array<τ_1_0>>) -> ()",
        "function_ref @$ss8StrideToV12makeIterators0abD0VyxGyF : $@convention(method) <τ_0_0 where τ_0_0 : Strideable> (@in StrideTo<τ_0_0>) -> @out StrideToIterator<τ_0_0>",
        "load %117 : $*Optional<Int>",
        "metatype $@thick Self.Type",
        "metatype $@thin Int.Type",
        "store %88 to %89 : $*StrideTo<Int>",
        "string_literal utf8 \"Fatal error\"",
        // TODO(#24): Parse string literals with control characters.
        // "string_literal utf8 \"\\n\"",
        "struct_element_addr %235 : $*Float, #Float._value",
        "switch_enum %122 : $Optional<Int>, case #Optional.some!enumelt.1: bb11, case #Optional.none!enumelt: bb18",
        "tuple ()",
        "tuple (%a : $A, %b : $B)",
        // TODO(#23): Parse tuple types with argument labels
        // "tuple $(a:A, b:B) (%a, %b)",
        "unreachable",
        "witness_method $Self, #Comparable.\"<=\"!1 : <Self where Self : Comparable> (Self.Type) -> (Self, Self) -> Bool : $@convention(witness_method: Comparable) <τ_0_0 where τ_0_0 : Comparable> (@in_guaranteed τ_0_0, @in_guaranteed τ_0_0, @thick τ_0_0.Type) -> Bool"
    ]

    // In order to declare this as `let instructionDef: String`, we need to write an appropriate init.
    // In that init, we need to delegate to the superclass init that involves `NSInvocation`.
    // That doesn't seem possible, so we use this hack.
    // error: 'NSInvocation' is unavailable in Swift: NSInvocation and related APIs not available.
    private var instructionDef: String!

    public func testRoundtrip() {
        do {
            let p = SILParser(forString: instructionDef)
            let i = try p.parseInstructionDef()
            XCTAssertEqual(instructionDef, i.description)
        } catch {
            XCTFail(String(describing: error) + "\n" + instructionDef)
        }
    }

    override class var defaultTestSuite: XCTestSuite {
        let testSuite = XCTestSuite(name: NSStringFromClass(self))
        for instructionDef in instructionDefs {
            for invocation in testInvocations {
                let testCase = InstructionTests(invocation: invocation)
                testCase.instructionDef = instructionDef
                testSuite.addTest(testCase)
            }
        }
        return testSuite
    }
}
#endif
